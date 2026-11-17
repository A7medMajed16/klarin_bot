import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart' show AudioPlayer, ProcessingState;
import 'package:toastification/toastification.dart';
import 'package:vibration/vibration.dart' show Vibration;

import '../../../config/extensions/theme_extensions.dart';
import '../../../theme/app_assets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';

class CustomToast {
  final BuildContext context;
  final String? header;
  final String? description;
  final CustomToastType type;
  final bool isWeb;

  CustomToast({
    required this.context,
    this.header,
    this.description,
    CustomToastType? type,
    this.isWeb = kIsWeb,
  }) : type = type ?? CustomToastType.defaultToast;

  static ToastificationItem? _currentToast;

  //!============================= DEFAULT TOAST =============================

  void showToast() {
    if (_currentToast != null) {
      toastification.dismiss(_currentToast!);
    }

    if (!kIsWeb) {
      _playSound();
      Vibration.vibrate(duration: 250);
    }

    final backgroundColor = type.backgroundColor;
    final textColor = type.textColor;

    _currentToast = toastification.show(
      primaryColor: backgroundColor,
      style: ToastificationStyle.fillColored,
      alignment: isWeb ? AlignmentDirectional.topEnd : Alignment.topCenter,
      closeOnClick: true,
      dragToClose: true,
      showIcon: false,
      context: context,
      borderSide: BorderSide.none,
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(AppWidgetTheme.defaultBorderRadius),
      applyBlurEffect: true,
      boxShadow: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.5),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            type.iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          Expanded(
            child: Text(
              header ?? "",
              style: 16.regular.copyWith(color: textColor),
            ),
          ),
          const SizedBox(),
        ],
      ),
      description: description != null
          ? Text(description!, style: 14.regular.copyWith(color: textColor))
          : null,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  //!============================= ALERT TOAST =============================
  void showAlertToast({
    String? icon,
    Color? mainColor,
    Color? backgroundColor,
    String? title,
    String? message,
  }) {
    if (_currentToast != null) {
      toastification.dismiss(_currentToast!);
    }

    if (!kIsWeb) {
      _playSound();
      Vibration.vibrate(duration: 500);
    }

    final isDarkMode = context.isDarkMode;

    _currentToast = toastification.show(
      primaryColor:
          backgroundColor ??
          (isDarkMode
              ? AppWidgetTheme.toastAlertBackgroundDark
              : AppWidgetTheme.toastAlertBackgroundLight),
      style: ToastificationStyle.fillColored,
      alignment: isWeb ? AlignmentDirectional.topEnd : Alignment.topCenter,
      closeOnClick: false,
      dragToClose: true,
      showProgressBar: false,
      showIcon: false,
      context: context,
      applyBlurEffect: true,
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      title: icon != null
          ? Center(child: SvgPicture.asset(icon, width: 24, height: 24))
          : null,
      description: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (title != null)
            Text(
              title,
              textAlign: TextAlign.center,
              style: 18.semiBold.copyWith(color: AppColors.black04),
            ),
          Text(
            message ?? "",
            textAlign: TextAlign.center,
            style: 14.medium.copyWith(color: AppColors.gray52),
          ),
        ],
      ),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future<void> _playSound() async {
    final audioPlayer = AudioPlayer();
    try {
      final soundPath = type == CustomToastType.error
          ? AppAssets.sounds.error
          : AppAssets.sounds.success;

      // Load the asset and wait for it to be ready
      await audioPlayer.setAsset(soundPath);

      // Play and wait for completion
      audioPlayer.play();

      // Listen for playback completion then dispose
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          audioPlayer.dispose();
        }
      });
    } catch (e) {
      // Silently fail if audio cannot be played (common on iOS Simulator)
      debugPrint('Audio playback failed: $e');
      audioPlayer.dispose();
    }
  }
}

//!============================= Custom Toast Types =============================
enum CustomToastType {
  success(
    textColor: AppWidgetTheme.toastTextColor,
    backgroundColor: AppWidgetTheme.toastSuccessColor,
  ),
  error(
    textColor: AppWidgetTheme.toastTextColor,
    backgroundColor: AppWidgetTheme.toastErrorColor,
  ),
  warning(
    textColor: AppWidgetTheme.toastTextColor,
    backgroundColor: AppWidgetTheme.toastWarningColor,
  ),
  defaultToast(
    textColor: AppWidgetTheme.toastTextColor,
    backgroundColor: AppWidgetTheme.toastDefaultColor,
  );

  const CustomToastType({
    required this.textColor,
    required this.backgroundColor,
  });

  final Color textColor;
  final Color backgroundColor;

  String get iconPath => switch (this) {
    CustomToastType.success => AppAssets.icons.done.path,
    CustomToastType.error => AppAssets.icons.error.path,
    CustomToastType.warning => AppAssets.icons.alert.path,
    CustomToastType.defaultToast => AppAssets.icons.normalWarning.path,
  };
}
