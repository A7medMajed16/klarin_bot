// import 'dart:async';
// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:injectable/injectable.dart';

// import '../api/errors/failure.dart';
// import '../cache/storage/cache_helper.dart';
// import '../helper/core/app_logger.dart';
// import '../utils/constants/app_cache_keys.dart';
// import '../utils/constants/location_constants.dart';
// import 'location_task_handler.dart';

// @lazySingleton
// class LocationService {
//   //! ─── State ───
//   Position? _lastLoggedPosition;
//   StreamSubscription<Position>? _positionSubscription;
//   bool _isTracking = false;

//   final StreamController<Position> _loggedPositionController =
//       StreamController<Position>.broadcast();
//   Stream<Position> get loggedPositionStream => _loggedPositionController.stream;

//   bool get isTracking => _isTracking;

//   //! ─── Initialization ───
//   LocationService() {
//     _initForegroundTask();
//   }

//   void _initForegroundTask() {
//     FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'location_tracking_channel',
//         channelName: 'Location Tracking',
//         channelDescription:
//             'This notification appears when tracking your location.',
//         channelImportance: NotificationChannelImportance.LOW,
//         priority: NotificationPriority.LOW,
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(
//         showNotification: false,
//         playSound: false,
//       ),
//       foregroundTaskOptions: ForegroundTaskOptions(
//         eventAction: ForegroundTaskEventAction.repeat(
//           LocationConstants.locationIntervalMs,
//         ),
//         autoRunOnBoot: false,
//         allowWakeLock: true,
//         allowAutoRestart: false,
//         stopWithTask: true,
//       ),
//     );
//   }

//   //! ─── Tracking Lifecycle ───
//   Future<Either<Failure, void>> startTracking() async {
//     if (_isTracking) return const Right(null);

//     //? 1. Check & Request Permissions
//     final permissionResult = await _requestPermissions();
//     if (permissionResult.isLeft()) {
//       return permissionResult;
//     }

//     //? 2. Load last logged position
//     _loadLastLoggedPosition();

//     //? 3. Start Foreground Task (Android)
//     if (Platform.isAndroid &&
//         await FlutterForegroundTask.isRunningService == false) {
//       await FlutterForegroundTask.startService(
//         notificationTitle: 'Alfares Pro Driver',
//         notificationText: 'Tracking location in background',
//         callback: startCallback,
//       );
//     }

//     //? 4. Start Position Stream (platform-specific)
//     late LocationSettings locationSettings;

//     if (Platform.isIOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: LocationConstants.distanceFilterMeters.toInt(),
//         activityType: ActivityType.automotiveNavigation,
//         allowBackgroundLocationUpdates: true,
//         showBackgroundLocationIndicator: true,
//         pauseLocationUpdatesAutomatically: false,
//       );
//     } else {
//       locationSettings = AndroidSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: LocationConstants.distanceFilterMeters.toInt(),
//         intervalDuration: Duration(
//           milliseconds: LocationConstants.locationIntervalMs,
//         ),
//         foregroundNotificationConfig: const ForegroundNotificationConfig(
//           notificationTitle: 'Alfares Pro Driver',
//           notificationText: 'Tracking location in background',
//           enableWakeLock: true,
//         ),
//       );
//     }

//     _positionSubscription =
//         Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//           _onPositionUpdate,
//           onError: (e) {
//             AppLogger.error('Location stream error: $e');
//           },
//         );

//     _isTracking = true;
//     AppLogger.success('Location tracking started');
//     return const Right(null);
//   }

//   Future<void> stopTracking() async {
//     if (!_isTracking) return;

//     _positionSubscription?.cancel();
//     _positionSubscription = null;

//     if (Platform.isAndroid) {
//       await FlutterForegroundTask.stopService();
//     }

//     _isTracking = false;
//     AppLogger.info('Location tracking stopped');
//   }

//   //! ─── Distance Logic ───
//   void _onPositionUpdate(Position position) {
//     if (_shouldLog(position)) {
//       _saveLastLoggedPosition(position);

//       // Emit to stream for UI or other listeners
//       _loggedPositionController.add(position);

//       // Console log (future hook for API integration or offline queuing)
//       AppLogger.success(
//         'Location Logged -> Lat: ${position.latitude}, Lng: ${position.longitude}',
//         tag: 'LocationService',
//       );
//     }
//   }

//   bool _shouldLog(Position current) {
//     if (_lastLoggedPosition == null) return true;

//     final distance = Geolocator.distanceBetween(
//       _lastLoggedPosition!.latitude,
//       _lastLoggedPosition!.longitude,
//       current.latitude,
//       current.longitude,
//     );
//     AppLogger.info("Distance: $distance");
//     return distance >= LocationConstants.minDistanceMeters;
//   }

//   //! ─── Persistence ───
//   void _loadLastLoggedPosition() {
//     final lat = SP.getDouble(key: AppCacheKeys.lastLoggedLatitude);
//     final lng = SP.getDouble(key: AppCacheKeys.lastLoggedLongitude);
//     final timestampStr = SP.getString(key: AppCacheKeys.lastLoggedTimestamp);

//     if (lat != null && lng != null && timestampStr != null) {
//       final timestamp = DateTime.tryParse(timestampStr);
//       if (timestamp != null) {
//         _lastLoggedPosition = Position(
//           longitude: lng,
//           latitude: lat,
//           timestamp: timestamp,
//           accuracy: 0,
//           altitude: 0,
//           heading: 0,
//           speed: 0,
//           speedAccuracy: 0,
//           altitudeAccuracy: 0,
//           headingAccuracy: 0,
//         );
//       }
//     }
//   }

//   void _saveLastLoggedPosition(Position position) {
//     _lastLoggedPosition = position;
//     SP.setDouble(
//       key: AppCacheKeys.lastLoggedLatitude,
//       value: position.latitude,
//     );
//     SP.setDouble(
//       key: AppCacheKeys.lastLoggedLongitude,
//       value: position.longitude,
//     );
//     SP.setString(
//       key: AppCacheKeys.lastLoggedTimestamp,
//       value: position.timestamp.toIso8601String(),
//     );
//   }

//   Future<void> dispose() async {
//     await stopTracking();
//     await _loggedPositionController.close();
//   }

//   //! ─── Permissions Flow ───
//   Future<Either<Failure, void>> _requestPermissions() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Left(
//         LocationFailure(errorMessage: "Location services are disabled."),
//       );
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Left(
//           LocationFailure(errorMessage: "Location permissions are denied"),
//         );
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Left(
//         LocationFailure(
//           errorMessage:
//               "Location permissions are permanently denied, we cannot request permissions.",
//         ),
//       );
//     }

//     // On iOS: request "Always Allow" so location works on locked screen.
//     // On Android 10+: background location must be requested separately.
//     if (permission == LocationPermission.whileInUse) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.always) {
//         // Tracking will still work while app is in foreground/background
//         // with screen on, but may be suspended on a locked screen.
//         AppLogger.info(
//           'Background "Always" permission not granted. '
//           'Locked-screen tracking may be limited.',
//           tag: 'LocationService',
//         );
//       }
//     }

//     return const Right(null);
//   }

//   //! ─── Existing Methods (Kept & adapted) ───
//   Future<Either<Failure, Position>> getCurrentLocation() async {
//     final permResult = await _requestPermissions();
//     if (permResult.isLeft()) {
//       return Left((permResult as Left).value);
//     }

//     try {
//       final position = await Geolocator.getCurrentPosition();
//       return Right(position);
//     } catch (e) {
//       return Left(LocationFailure(errorMessage: 'Failed to get location: $e'));
//     }
//   }

//   static Future<String> getAddressTitle(double lat, double lng) async {
//     try {
//       await setLocaleIdentifier('ar');
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return "${place.administrativeArea}, ${place.locality}, ${place.street}";
//       }
//       return "";
//     } catch (e) {
//       return "";
//     }
//   }
// }
