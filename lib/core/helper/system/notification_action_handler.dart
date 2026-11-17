import '../core/app_logger.dart';

class NotificationActionHandler {
  /// Called when a notification is received (foreground/background while app alive)
  /// Reloads orders if orderId is present in the payload
  static void handleNotificationReceived(Map<String, dynamic> data) {
    AppLogger.info(
      "handleNotificationReceived ",
      tag: "ForegroundNotification",
    );
  }

  /// Called when the user taps on a notification
  /// Navigates to OrderDetailsScreen if orderId is present
  static void handleNotificationTap(Map<String, dynamic> data) {}
}
