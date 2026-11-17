import 'dart:developer' show log;

import 'package:flutter/foundation.dart';

/// A custom logger for the application that only works in debug mode.
/// Standardizes log output across the app with consistent formatting and colors.
abstract class AppLogger {
  /// Internal method to handle printing with ANSI color codes.
  static void _log(
    dynamic message, {
    String? tag,
    required String colorCode,
    String label = 'LOG',
  }) {
    if (kDebugMode) {
      final timestamp = DateTime.now()
          .toString()
          .split('.')
          .first
          .split(' ')
          .last;
      final tagStr = tag != null ? '[$tag] ' : '';

      // Using ANSI escape codes for coloring:
      // \x1B[ - Escape sequence
      // ${colorCode} - Color ID (e.g., 32 for green)
      // m - End of escape sequence
      // \x1B[0m - Reset sequence
      log(
        '\x1B[${colorCode}m[$label] $timestamp $tagStr$message\x1B[0m',
      );
    }
  }

  /// Logs a success message in green.
  static void success(dynamic message, {String? tag}) {
    _log(message, tag: tag, colorCode: '92', label: 'SUCCESS');
  }

  /// Logs an info message in cyan.
  static void info(dynamic message, {String? tag}) {
    _log(message, tag: tag, colorCode: '93', label: 'INFO');
  }

  /// Logs an error message in red.
  static void error(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log(message, tag: tag, colorCode: '91', label: 'ERROR');
    if (error != null && kDebugMode) {
      log('\x1B[31mError Details: $error\x1B[0m');
    }
    if (stackTrace != null && kDebugMode) {
      log('\x1B[31m$stackTrace\x1B[0m');
    }
  }

  /// Logs a deep purple message for heavy debugging or specialized data.
  static void debug(dynamic message, {String? tag}) {
    _log(message, tag: tag, colorCode: '95', label: 'DEBUG');
  }
}
