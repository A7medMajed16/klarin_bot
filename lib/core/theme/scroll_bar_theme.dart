import 'package:material_ui/material_ui.dart';

import 'app_widget_theme.dart';

ScrollbarThemeData customScrollTheme = ScrollbarThemeData(
  thumbColor: WidgetStatePropertyAll<Color>(AppWidgetTheme.scrollbarThumbColor),
  trackColor: WidgetStatePropertyAll<Color>(AppWidgetTheme.scrollbarTrackColor),
  thickness: WidgetStatePropertyAll<double>(6),
  thumbVisibility: WidgetStatePropertyAll<bool>(true),
  trackVisibility: WidgetStatePropertyAll<bool>(false),
  interactive: true,
  crossAxisMargin: 2,
  mainAxisMargin: 2,
  trackBorderColor: WidgetStatePropertyAll(Colors.transparent),
  radius: const Radius.circular(9999),
);

class NoScrollbarBehavior extends ScrollBehavior {
  const NoScrollbarBehavior();
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
