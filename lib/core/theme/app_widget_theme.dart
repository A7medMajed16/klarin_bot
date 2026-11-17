import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Centralized design tokens for all custom widgets in the core module.
/// Use these constants instead of hardcoding colors/radii in widget files.
abstract class AppWidgetTheme {
  //!======== Border Radii ========
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;

  //!======== Border Colors ========
  static const Color errorBorderColor = AppColors.originalRed;

  //!======== Text Field ========
  static const Color textFieldFillColor = AppColors.originalWhite;
  static const Color textFieldDisabledFillColor = AppColors.grayFD;
  static const Color textFieldBorderColor = AppColors.grayE4;
  static const Color textFieldFocusBorderColor =
      AppColors.primerColor;
  static const Color textFieldErrorBorderColor =
      AppColors.originalRed;
  static const Color textFieldHintColor = AppColors.gray71;
  static const Color textFieldDisabledHintColor = AppColors.grayB6;
  static const Color textFieldCursorColor = AppColors.originalBlack;
  static const Color textFieldErrorTextColor = AppColors.originalRed;
  static const Color textFieldHoverColor = AppColors.purple97B10;
  static const Color textFieldTitleColor = AppColors.black27;
  static const Color textFieldPrefixIconColor = AppColors.gray99;

  //!======== Button ========
  static Color buttonDisabledColor = AppColors.gray99.withValues(
    alpha: 0.5,
  );
  static const Color buttonLoadingIndicatorColor =
      AppColors.originalWhite;
  static const Color buttonShadowColor = AppColors.primerColorB25;

  //!======== Selection Widgets ========
  static const Color tileBackgroundColor = AppColors.grayF4;
  static const Color selectedTileColor = AppColors.primerColorB32;
  static const Color tileSplashColor = AppColors.primerColorB25;
  static const Color tileHoverColor = AppColors.primerColorB32;
  static const Color tileBorderColor = AppColors.grayE4;
  static const Color tileIconColor = AppColors.gray71;

  //!======== Pin Input ========
  static const Color pinDefaultBackgroundColor = AppColors.grayF4;
  static const Color pinFocusedBackgroundColor =
      AppColors.purple97B10;
  static Color pinShadowColor = AppColors.originalBlack.withValues(
    alpha: 0.05,
  );

  //!======== Toast / Notifications ========
  static const Color toastSuccessColor = AppColors.green17;
  static const Color toastErrorColor = AppColors.originalRed;
  static const Color toastWarningColor = AppColors.purple97;
  static const Color toastDefaultColor = AppColors.primerColor;
  static const Color toastTextColor = AppColors.originalWhite;

  static const Color toastAlertBackgroundLight =
      AppColors.originalWhite;
  static const Color toastAlertBackgroundDark = AppColors.black27;
  static const Color toastAlertTextLight = AppColors.primerColor;
  static const Color toastAlertTextDark = AppColors.originalWhite;
  static Color toastAlertIconBackgroundLight = AppColors.primerColor
      .withValues(alpha: 0.1);
  static Color toastAlertIconBackgroundDark = AppColors.originalWhite
      .withValues(alpha: 0.1);

  //!======== Misc ========
  static const Color switchActiveColor = AppColors.purple97;
  static const Color loadingIndicatorColor = AppColors.primerColor;
  static Color imageBackgroundColor = AppColors.originalBlack
      .withValues(alpha: 0.1);
  static Color barrierColor = AppColors.originalBlack.withValues(
    alpha: 0.1,
  );

  //!======== Dialogs ========
  static const Color popUpIconDefaultColor = AppColors.gray71;
  static const Color popUpDividerDefaultColor = AppColors.grayE4;

  //!======== Date Picker ========
  static const Color datePickerTextColor = AppColors.black27;
  static const Color datePickerIconColor = AppColors.gray52;

  //!======== Scrollbar ========
  static const Color scrollbarThumbColor = AppColors.black27;
  static const Color scrollbarTrackColor = AppColors.grayE4;

  //!======== App Bar ========
  static const Color appBarShadowColor = AppColors.primerColorB32;
}
