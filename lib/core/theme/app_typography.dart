import 'package:material_ui/material_ui.dart';

import '../cache/models/lang.dart';
import '../utils/constants/app_strings.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static String _locale = arabic;
  static Brightness _brightness = Brightness.light;

  static const Map<String, String> _fontFamilies = {
    arabic: AppStrings.arabicFontFamily,
  };

  static const Map<Brightness, Color> _textColors = {
    Brightness.light: AppColors.originalBlack,
    Brightness.dark: AppColors.originalWhite,
  };

  static void setLocale(String locale) => _locale = locale;

  static void setTheme(Brightness brightness) =>
      _brightness = brightness;

  static String get locale => _locale;

  static Brightness get brightness => _brightness;

  static String get fontFamily =>
      _fontFamilies[_locale] ?? _fontFamilies[arabic]!;

  static Color get textColor => _textColors[_brightness]!;

  /// Retrieve the defined color natively for injecting into ThemeData
  static Color getTextColorFor(Brightness brightness) =>
      _textColors[brightness]!;
}

extension TextStyleExtension on num {
  TextStyle get bold => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w700,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get semiBold => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w600,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get medium => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w500,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get regular => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w400,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get light => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w300,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get extraLight => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w200,
    fontFamily: AppTypography.fontFamily,
  );

  TextStyle get black => TextStyle(
    fontSize: toDouble(),
    fontWeight: FontWeight.w900,
    fontFamily: AppTypography.fontFamily,
  );
}

extension LocaleExtensions on BuildContext {
  String get languageCode {
    try {
      return (this as dynamic).locale.languageCode as String;
    } catch (_) {
      return Localizations.localeOf(this).languageCode;
    }
  }
}
