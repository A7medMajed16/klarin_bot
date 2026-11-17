import 'package:material_ui/material_ui.dart';

extension ThemeExtensions on BuildContext {
  /// Returns true if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns a color based on the current theme mode
  Color color(Color light, Color dark) => isDarkMode ? dark : light;
}
