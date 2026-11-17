import 'dart:ui' show Locale;

class AppLocals {
  static const Locale arabicLocal = Locale('ar', 'EG');
  static const Locale englishLocal = Locale('en', 'US');
  static const List<Locale> supportedLocales = [
    arabicLocal,
    englishLocal,
  ];
  static const String assetsLocalization = 'lib/core/localization';
}
