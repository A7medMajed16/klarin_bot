// import 'dart:async';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// import '../helper/core/app_logger.dart';

// @pragma('vm:entry-point')
// void startCallback() {
//   FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
// }

// class LocationTaskHandler extends TaskHandler {
//   @override
//   Future<void> onStart(
//     DateTime timestamp,
//     TaskStarter starter,
//   ) async {
//     AppLogger.info('Location foreground task started');
//   }

//   @override
//   void onRepeatEvent(DateTime timestamp) {
//     // We don't necessarily need to do anything here because Geolocator's stream
//     // handles the location updates. The foreground task just keeps the app alive.
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp, bool foreground) async {
//     AppLogger.info('Location foreground task destroyed');
//   }
// }
