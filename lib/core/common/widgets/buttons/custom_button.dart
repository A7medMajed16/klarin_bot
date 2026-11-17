import 'package:easy_localization/easy_localization.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.title,
    this.leading,
    this.backGroundColor = AppColors.primerColor,
    this.isFilled = true,
    this.useGradient = true,
    this.borderColor,
    this.titleStyle,
    this.width,
    this.height,
    this.isLoading = false,
    this.elevation,
    this.radius,
    this.isExpanded = true,
    this.padding,
  });
  final void Function()? onTap;
  final String? title;
  final Widget? leading;
  final Color? backGroundColor, borderColor;
  final bool isFilled, isLoading, isExpanded, useGradient;
  final double? width, height, elevation, radius;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;

  bool get _showGradient => isFilled && useGradient;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? 16);

    return AnimatedContainer(
      width: isExpanded
          ? isLoading
                ? 220
                : width ?? 1.sw
          : null,
      height: height ?? 50,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutBack,
      decoration: _showGradient
          ? BoxDecoration(
              gradient: onTap != null
                  ? AppColors.primerGradient
                  : null,
              color: onTap == null
                  ? AppWidgetTheme.buttonDisabledColor
                  : null,
              borderRadius: borderRadius,
              boxShadow: elevation != null
                  ? [
                      BoxShadow(
                        color: AppWidgetTheme.buttonShadowColor,
                        blurRadius: elevation!,
                      ),
                    ]
                  : null,
            )
          : null,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          padding: padding,
          splashFactory: NoSplash.splashFactory,
          disabledBackgroundColor: _showGradient
              ? Colors.transparent
              : AppWidgetTheme.buttonDisabledColor,
          backgroundColor: _showGradient
              ? Colors.transparent
              : isFilled
                  ? backGroundColor
                  : Colors.transparent,
          overlayColor:
              isFilled && backGroundColor != Colors.transparent
              ? AppColors.primerColor
              : backGroundColor != Colors.transparent
              ? backGroundColor
              : borderColor,
          side: isFilled && borderColor == null
              ? null
              : BorderSide(
                  width: 1,
                  color: borderColor ?? Colors.transparent,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          shadowColor: _showGradient
              ? Colors.transparent
              : elevation != null
                  ? AppWidgetTheme.buttonShadowColor
                  : null,
          elevation: _showGradient
              ? 0
              : elevation ?? (isFilled ? null : 0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: isExpanded
              ? MainAxisSize.max
              : MainAxisSize.min,
          children: [
            isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CupertinoActivityIndicator(
                        color: AppWidgetTheme
                            .buttonLoadingIndicatorColor,
                      ),
                    ),
                  )
                : leading ?? const SizedBox(),
            if (leading != null && title != null && !isLoading)
              const SizedBox(width: 8),
            if (title != null)
              Flexible(
                child: Text(
                  isLoading ? "custom_widget.loading".tr() : title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      titleStyle ??
                      18.semiBold.copyWith(
                        color: isFilled
                            ? AppColors.originalWhite
                            : backGroundColor,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
