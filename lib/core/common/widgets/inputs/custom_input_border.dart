import 'package:material_ui/material_ui.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_widget_theme.dart';

/// Shared [OutlineInputBorder] builder used by all input widgets.
OutlineInputBorder customOutLineBorders({
  double? borderRadius,
  Color? borderColor,
  double? borderWidth,
}) {
  return OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(borderRadius ?? AppWidgetTheme.defaultBorderRadius),
    borderSide: BorderSide(
      color: borderColor ?? AppColors.grayE4,
      width: borderWidth ?? 0.5,
    ),
  );
}
