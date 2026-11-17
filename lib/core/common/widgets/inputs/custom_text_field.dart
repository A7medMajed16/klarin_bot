import 'dart:io' show Platform;
import '../../../helper/formatters/safe_text_input_formatter.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';
import 'custom_input_border.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
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
  });
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
  final double? spacing;
  final TextInputType? textInputType;
  final bool enableFocusBorder;
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
            style:
                titleStyle ??
                14.light.copyWith(color: AppWidgetTheme.textFieldTitleColor),
          ),
        TextFormField(
          enabled: !isReadOnly,
          textDirection: textDirection,
          inputFormatters: _resolvedInputFormatters,
          style: _resolvedTextStyle,

          obscuringCharacter: "*",
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: onSaved,
          onEditingComplete: onEditingComplete,
          onTap: onTap,
          onChanged: onChanged,
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
          initialValue: initialValue,
          controller: controller,
          maxLines: maxLine,
          textAlign: textAlign ?? TextAlign.start,
          keyboardType: textInputType,

          cursorColor: AppWidgetTheme.textFieldCursorColor,

          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            fillColor: !isReadOnly
                ? fillColor ?? AppWidgetTheme.textFieldFillColor
                : AppWidgetTheme.textFieldDisabledFillColor,
            filled: enableFill,
            isDense: isDense,
            hintText: hintText,
            hintTextDirection: textDirection,
            hoverColor: AppWidgetTheme.textFieldHoverColor,
            hintStyle:
                hintStyle ??
                14.light.copyWith(
                  color: !isReadOnly
                      ? AppWidgetTheme.textFieldHintColor
                      : AppWidgetTheme.textFieldDisabledHintColor,
                ),
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
            suffixIcon: suffixWidget,
            suffixText: suffixText,
            suffixStyle: suffixTextStyle,
            prefixIcon: prefixIcon != null
                ? SvgPicture.asset(
                    prefixIcon!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.scaleDown,
                    colorFilter: const ColorFilter.mode(
                      AppWidgetTheme.textFieldPrefixIconColor,
                      BlendMode.srcIn,
                    ),
                  )
                : prefixWidget,
            label: labelWidget,
            floatingLabelBehavior:
                floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            errorBorder:
                enabledBorder ??
                customOutLineBorders(borderColor: AppColors.originalRed),
            disabledBorder: disabledBorder ?? customOutLineBorders(),
            border: border ?? customOutLineBorders(),
            enabledBorder: enabledBorder ?? customOutLineBorders(),
            focusedBorder:
                focusedBorder ??
                customOutLineBorders(
                  borderColor: enableFocusBorder ? AppColors.primerColor : null,
                  borderWidth: 1.5,
                ),
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter> get _resolvedInputFormatters {
    final formatters = <TextInputFormatter>[
      // Repair iOS custom-OTF paste corruption (ASCII → U+XX00).
      SafeTextInputFormatter.repair,
    ];

    if (textInputType == TextInputType.phone) {
      formatters.add(SafeTextInputFormatter.phone);
    } else if (textInputType == TextInputType.number) {
      formatters.add(SafeTextInputFormatter.digits);
    }

    if (inputFormatters != null) {
      formatters.addAll(inputFormatters!);
    }
    return formatters;
  }

  TextStyle get _resolvedTextStyle {
    final base = textStyle ?? 16.regular;
    if (!Platform.isIOS) return base;
    return TextStyle(
      color: base.color,
      fontSize: base.fontSize,
      fontWeight: base.fontWeight,
      fontStyle: base.fontStyle,
      height: base.height,
      letterSpacing: base.letterSpacing,
      wordSpacing: base.wordSpacing,
      decoration: base.decoration,
      decorationColor: base.decorationColor,
      decorationStyle: base.decorationStyle,
      decorationThickness: base.decorationThickness,
      fontFamilyFallback: const [
        'SF Pro Text',
        'SFProText',
        'Helvetica Neue',
        'Helvetica',
        'Arial',
      ],
    );
  }
}
