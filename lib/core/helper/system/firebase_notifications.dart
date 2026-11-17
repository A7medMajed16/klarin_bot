import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/constants/app_strings.dart';
import '../core/app_logger.dart';
import 'notification_action_handler.dart';

class FirebaseNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _channelId = '${AppStrings.appName}_notifications';
  static const String _channelName = '${AppStrings.appName} Notifications';
  static const String _channelDescription =
      '${AppStrings.appName} app notifications';

  // Initialize Firebase and notifications
  static Future<void> initializeFirebase() async {
    try {
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      // Initialize local notifications
      await _initializeLocalNotifications();

      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request notification permissions
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Handle permission status
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          AppLogger.success('User granted permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          AppLogger.success('User granted provisional permission');
        }
      } else {
        if (kDebugMode) {
          AppLogger.error('User denied permission');
        }
      }

      // iOS: retrieve APNs token (required for push notifications)
      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        if (kDebugMode) {
          AppLogger.info('APNs Token: $apnsToken');
        }
        // If APNs token is null, wait briefly and retry
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await messaging.getAPNSToken();
          if (kDebugMode) {
            AppLogger.info('APNs Token (retry): $apnsToken');
          }
        }
      }

      // Register with FCM; onRegistered emits the installation ID (FID)
      // to send to the backend for direct-send messaging.
      messaging.onRegistered.listen((fid) {
        if (kDebugMode) {
          AppLogger.info('FCM Installation ID: $fid');
        }
      });
      await messaging.register();

      // Set up message handlers
      _setupMessageHandlers();
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error initializing Firebase: $e');
      }
    }
  }

  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/notification_icon');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            requestCriticalPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      // iOS: enable native foreground notification presentation
      // (iOS will show the notification banner natively)
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      // iOS: request local notification permissions
      if (Platform.isIOS) {
        final bool? iosPermission = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        if (kDebugMode) {
          AppLogger.info(
            'iOS local notification permission granted: $iosPermission',
          );
        }
      }

      // Android: request permissions and create notification channel
      if (Platform.isAndroid) {
        final androidPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        // Request POST_NOTIFICATIONS permission using permission_handler (Android 13+)
        final notifStatus = await Permission.notification.request();
        if (kDebugMode) {
          AppLogger.info(
            'Android notification permission status: $notifStatus',
          );
        }

        // If permanently denied, open app settings so user can enable manually
        if (notifStatus.isPermanentlyDenied) {
          if (kDebugMode) {
            AppLogger.error(
              'Notification permission permanently denied, opening app settings...',
            );
          }
          await openAppSettings();
        }

        // Create notification channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        );
        await androidPlugin?.createNotificationChannel(channel);
      }

      // Initialize the local notifications plugin
      await _flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap
          if (response.payload != null && response.payload!.isNotEmpty) {
            if (kDebugMode) {
              AppLogger.info('Notification payload: ${response.payload}');
            }
            try {
              final data =
                  jsonDecode(response.payload!) as Map<String, dynamic>;
              NotificationActionHandler.handleNotificationTap(data);
            } catch (e) {
              if (kDebugMode) {
                AppLogger.error('Error parsing notification payload: $e');
              }
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error initializing local notifications: $e');
      }
    }
  }

  // Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final RemoteNotification? notification = message.notification;

      if (notification != null) {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDescription,
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              icon: '@drawable/ic_notification',
              playSound: true,
              enableVibration: true,
            );

        const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iOSDetails,
        );

        await _flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: notificationDetails,
          payload: jsonEncode(message.data),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error showing local notification: $e');
      }
    }
  }

  // Setup all message handlers
  static void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        AppLogger.info(
          'Foreground message received: ${message.notification?.title}',
        );
        AppLogger.info('Message data: ${message.data}');
      }

      // Trigger order reload on notification received
      NotificationActionHandler.handleNotificationReceived(message.data);

      // On Android, show via local notifications (iOS handles it natively
      // via setForegroundNotificationPresentationOptions)
      if (Platform.isAndroid) {
        _showLocalNotification(message);
      }
    });

    // Background messages - Do NOT show notifications (only handle data)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // When app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        AppLogger.debug(
          'App opened from notification: ${message.notification?.title}',
        );
      }
      NotificationActionHandler.handleNotificationTap(message.data);
    });

    // App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        if (kDebugMode) {
          AppLogger.debug(
            'App opened from terminated state: ${message.notification?.title}',
          );
        }
        NotificationActionHandler.handleNotificationTap(message.data);
      }
    });
  }
}

// Background message handler - Only process data, DO NOT show notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    AppLogger.info(
      'Background message received: ${message.notification?.title}',
    );
    AppLogger.info('Background message data: ${message.data}');
  }
  // var pref = await SharedPreferences.getInstance();
  // pref.setBool(AppCacheKeys.refreshOrders, true);
  // DO NOT show regular notifications in background
  // Notifications should only appear when app is in foreground
}

// ─────────────────────── Topic Management ─────────────────────────────────

class FirebaseTopicManager {
  /// The static topic name all devices subscribe to.

  /// Subscribe to the app's notification topic.
  ///
  /// Call after login or during app init when user is authenticated.
  static Future<void> subscribe() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // On iOS, APNS token must be available before subscribing
      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await messaging.getAPNSToken();
        }
        if (apnsToken == null) {
          if (kDebugMode) {
            log('APNS token not available — cannot subscribe to topic');
          }
          return;
        }
      }

      final List<String> topicsName = [];

      for (String topicName in topicsName) {
        if (kDebugMode) {
          log('Subscribed to topic: $topicName');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error subscribing to topic: $e');
      }
    }
  }

  /// Unsubscribe from the app's notification topic.
  ///
  /// Call on logout.
  static Future<void> unsubscribe() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // On iOS, APNS token must be available before unsubscribing
      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          if (kDebugMode) {
            log('APNS token not available — cannot unsubscribe from topic');
          }
          return;
        }
      }

      final List<String> topicsName = [];

      for (String topicName in topicsName) {
        await messaging.unsubscribeFromTopic(topicName);
        if (kDebugMode) {
          log('Unsubscribed from topic: $topicName');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error unsubscribing from topic: $e');
      }
    }
  }
}
