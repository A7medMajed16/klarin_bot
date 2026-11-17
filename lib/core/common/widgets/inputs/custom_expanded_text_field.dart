import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';
import 'custom_input_border.dart';

class CustomExpandedTextField extends StatelessWidget {
  final Widget? labelWidget;
  final double? borderRadius;
  final TextAlign? textAlign;
  final String? Function(String? value)? validator;
  final double? borderWidth;
  final Color? borderColor;
  final Color? fillColor;
  final bool enableFill;
  final Widget? suffixWidget;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final Widget? prefixWidget;
  final String? prefixIcon;
  final int? maxLine;
  final int? maxLines;
  final double? spacing;
  final TextInputType? textInputType;
  final bool enableFocusBorder, expanded;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final String? title;
  final TextStyle? hintStyle;
  final String? hintText;
  final TextStyle? titleStyle;
  final bool isObscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Color? focusBorderColor;
  final FocusNode? focusNode;
  final String? initialValue;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;

  final bool isReadOnly;
  final EdgeInsetsDirectional? contentPadding;
  final int? maxLength;
  final bool isDense;
  final InputBorder? border;
  final TextCapitalization? textCapitalization;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final TextDirection? textDirection;
  const CustomExpandedTextField({
    super.key,
    this.maxLine,
    this.isDense = false,
    this.validator,
    this.controller,
    this.enableFocusBorder = true,
    this.textInputType,
    this.suffixText,
    this.suffixTextStyle,
    this.labelWidget,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.prefixWidget,
    this.suffixWidget,
    this.textStyle,
    this.enableFill = true,
    this.fillColor,
    this.title,
    this.isObscureText = false,
    this.titleStyle,
    this.focusBorderColor,
    this.floatingLabelBehavior,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isReadOnly = false,
    this.spacing = 0,
    this.initialValue,
    this.inputFormatters,
    this.contentPadding,
    this.maxLength,
    this.textAlign,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onSaved,
    this.hintStyle,
    this.hintText,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.textDirection,
    this.disabledBorder,
    this.textCapitalization,
    this.prefixIcon,
    this.maxLines,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if (title != null && title!.isNotEmpty)
          Text(
            title ?? "",
            style: titleStyle ?? 14.light.copyWith(color: AppWidgetTheme.textFieldTitleColor),
          ),
        Stack(
          children: [
            TextFormField(
              enabled: !isReadOnly,
              textDirection: textDirection,
              obscuringCharacter: "*",
              textCapitalization:
                  textCapitalization ?? TextCapitalization.none,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: onSaved,
              onEditingComplete: onEditingComplete,
              onTap: onTap,
              onChanged: (value) {
                onChanged?.call(value);
              },
              onTapOutside: (pos) {
                FocusScope.of(context).unfocus();
              },
              autofocus: false,
              maxLength: maxLength,
              readOnly: isReadOnly,
              obscureText: isObscureText,
              validator: validator,
              focusNode: focusNode,
              textInputAction: textInputAction,
              initialValue: controller == null ? initialValue : null,
              controller: controller,
              maxLines: expanded ? maxLines : maxLine,
              minLines: expanded ? 1 : maxLine,
              scrollPhysics: expanded
                  ? const BouncingScrollPhysics()
                  : null,
              textAlign: textAlign ?? TextAlign.start,
              keyboardType: textInputType,
              inputFormatters: textInputType == TextInputType.phone
                  ? [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9+]'),
                      ),
                    ]
                  : inputFormatters,
              cursorColor: AppWidgetTheme.textFieldCursorColor,
              style: textStyle ?? 16.regular,
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                hoverColor: AppWidgetTheme.textFieldHoverColor,
                fillColor: fillColor,
                filled: enableFill,
                isDense: isDense,
                hintText: hintText,
                hintStyle:
                    hintStyle ??
                    14.light.copyWith(color: AppWidgetTheme.textFieldHintColor),
                contentPadding:
                    contentPadding ??
                    REdgeInsetsDirectional.only(
                      start: 12,
                      end: 12,
                      bottom: 10,
                      top: 10,
                    ),
                alignLabelWithHint: true,
                errorStyle: 12.regular.copyWith(
                  color: AppWidgetTheme.textFieldErrorTextColor,
                ),
                focusColor: Colors.black,
                suffixIconConstraints: expanded
                    ? BoxConstraints(maxHeight: 16, maxWidth: 16)
                    : null,

                suffixText: suffixText,
                suffixStyle: suffixTextStyle,
                prefixIcon: prefixIcon != null
                    ? SvgPicture.asset(
                        prefixIcon!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      )
                    : prefixWidget,
                label: labelWidget,
                floatingLabelBehavior:
                    floatingLabelBehavior ??
                    FloatingLabelBehavior.auto,
                errorBorder:
                    enabledBorder ??
                    customOutLineBorders(
                      borderColor: AppColors.originalRed,
                      borderRadius: borderRadius,
                    ),
                disabledBorder:
                    disabledBorder ??
                    customOutLineBorders(borderRadius: borderRadius),
                border:
                    border ??
                    customOutLineBorders(borderRadius: borderRadius),
                enabledBorder:
                    enabledBorder ??
                    customOutLineBorders(borderRadius: borderRadius),
                focusedBorder:
                    focusedBorder ??
                    customOutLineBorders(
                      borderColor: enableFocusBorder
                          ? AppColors.primerColor
                          : null,
                      borderWidth: 1.5,
                      borderRadius: borderRadius,
                    ),
              ),
            ),
            Positioned.directional(
              bottom: maxLength != null ? 26 : 8,
              end: 8,
              textDirection: context.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Icon(
                Icons.drag_indicator,
                size: 16,
                color: AppWidgetTheme.tileIconColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
