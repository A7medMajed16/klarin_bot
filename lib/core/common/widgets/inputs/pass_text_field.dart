import 'dart:io';

import '../../../helper/formatters/safe_text_input_formatter.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';
import 'custom_input_border.dart';

class PassTextFormField extends StatefulWidget {
  const PassTextFormField({
    super.key,
    this.validator,
    this.controller,
    this.enableFocusBorder = true,
    this.labelWidget,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.prefixWidget,
    this.textStyle,
    this.enableFill = true,
    this.fillColor,
    this.title,
    this.labelStyle,
    this.focusBorderColor,
    this.floatingLabelBehavior,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.headerText,
    this.isReadOnly = false,
    this.headerTextStyle,
    this.spacing = 0,
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
    this.isDense = false,
    this.obscuringCharacter,
    this.primer = false,
    this.showPasswordIcon,
    this.hidePasswordIcon,
    this.lockIcon,
  });

  final Widget? labelWidget;
  final double? borderRadius;
  final TextAlign? textAlign;
  final String? Function(String? value)? validator;
  final double? borderWidth;
  final Color? borderColor;
  final Color? fillColor;
  final bool enableFill;
  final Widget? prefixWidget;
  final double? spacing;
  final bool enableFocusBorder;
  final bool primer;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final String? title;
  final TextStyle? hintStyle;
  final String? hintText;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Color? focusBorderColor;
  final FocusNode? focusNode;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final String? headerText, obscuringCharacter;
  final TextStyle? headerTextStyle;
  final bool isReadOnly;
  final EdgeInsetsDirectional? contentPadding;
  final int? maxLength;
  final bool isDense;
  final String? showPasswordIcon;
  final String? hidePasswordIcon;
  final String? lockIcon;

  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final TextDirection? textDirection;

  @override
  State<PassTextFormField> createState() => _PassTextFormFieldState();
}

class _PassTextFormFieldState extends State<PassTextFormField> {
  bool _isPasswordVisible = false;
  FocusNode? _focusNode;
  List<bool> passwordConditionsState = [false, false, false, false, false];
  final List<String> passwordConditions = [
    "validations.set_password_1_condition",
    "validations.set_password_2_condition",
    "validations.set_password_3_condition",
    "validations.set_password_4_condition",
    "validations.set_password_5_condition",
  ];

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(() {
      _focusNode!.hasFocus ? setState(() {}) : null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty)
          Text(
            widget.title ?? "",
            style: 14.light.copyWith(color: AppWidgetTheme.textFieldTitleColor),
          ),
        TextFormField(
          focusNode: _focusNode,
          textDirection: widget.textDirection,
          obscuringCharacter: widget.obscuringCharacter ?? "•",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          onTap: widget.onTap,
          onChanged: widget.primer
              ? (value) => _updatePasswordConditions(value)
              : widget.onChanged,
          onTapOutside: (pos) {
            FocusScope.of(context).unfocus();
          },
          autofocus: false,
          maxLength: widget.maxLength,

          readOnly: widget.isReadOnly,
          obscureText: !_isPasswordVisible,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          maxLines: 1,
          inputFormatters: [
            SafeTextInputFormatter.repair,
            ...?widget.inputFormatters,
          ],
          style: _resolvedTextStyle,

          textAlign: widget.textAlign ?? TextAlign.start,
          keyboardType: TextInputType.visiblePassword,
          cursorColor: AppColors.primerColor,

          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            hoverColor: AppWidgetTheme.textFieldHoverColor,
            fillColor: widget.fillColor,
            filled: widget.enableFill,
            isDense: widget.isDense,
            counterText: "",
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ??
                14.light.copyWith(color: AppWidgetTheme.textFieldHintColor),
            contentPadding:
                widget.contentPadding ??
                REdgeInsetsDirectional.only(
                  start: 12,
                  end: 4,
                  bottom: 10,
                  top: 10,
                ),
            alignLabelWithHint: true,

            focusColor: Colors.black,
            suffixIcon: _buildToggleVisibilityButton(),
            prefixIcon:
                widget.prefixWidget ??
                (widget.lockIcon != null
                    ? SvgPicture.asset(
                        widget.lockIcon!,
                        colorFilter: ColorFilter.mode(
                          AppWidgetTheme.textFieldPrefixIconColor,
                          BlendMode.srcIn,
                        ),
                        width: 20,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      )
                    : Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppWidgetTheme.textFieldPrefixIconColor,
                      )),
            label: widget.labelWidget,
            floatingLabelBehavior:
                widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            errorBorder:
                widget.enabledBorder ??
                customOutLineBorders(borderColor: AppColors.originalRed),
            disabledBorder: widget.disabledBorder ?? customOutLineBorders(),
            border: widget.border ?? customOutLineBorders(),
            enabledBorder: widget.enabledBorder ?? customOutLineBorders(),
            focusedBorder:
                widget.focusedBorder ??
                customOutLineBorders(
                  borderColor: widget.enableFocusBorder
                      ? AppColors.primerColor
                      : null,
                  borderWidth: 1.5,
                ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOutBack,
          switchOutCurve: Curves.easeInOutBack,
          transitionBuilder: (child, animation) {
            return ClipRect(
              child: SizeTransition(
                sizeFactor: animation,
                alignment: Alignment(-1.0, 0),
                child: child,
              ),
            );
          },
          child: widget.primer && _focusNode!.hasFocus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: 3,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder: (child, animation) {
                                return ClipRect(
                                  child: SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                passwordConditionsState[index]
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                key: ValueKey<bool>(
                                  passwordConditionsState[index],
                                ),
                                size: 15,
                                color: passwordConditionsState[index]
                                    ? AppColors.green17
                                    : AppColors.originalRed,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                style: !passwordConditionsState[index]
                                    ? 14.regular.copyWith(
                                        color: AppColors.originalRed,
                                      )
                                    : 14.regular,
                                child: Text(passwordConditions[index]),
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 6),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,

                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder: (child, animation) {
                                return ClipRect(
                                  child: SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                passwordConditionsState[index + 3]
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                key: ValueKey<bool>(
                                  passwordConditionsState[index + 3],
                                ),
                                size: 15,
                                color: passwordConditionsState[index + 3]
                                    ? AppColors.green17
                                    : AppColors.originalRed,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                style: !passwordConditionsState[index + 3]
                                    ? 14.regular.copyWith(
                                        color: AppColors.originalRed,
                                      )
                                    : 14.regular,
                                child: Text(passwordConditions[index + 3]),
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 6),
                      ),
                    ),
                  ],
                )
              : const SizedBox(key: ValueKey('empty_password_conditions')),
        ),
      ],
    );
  }

  Widget _buildToggleVisibilityButton() {
    return IconButton(
      iconSize: 12,
      onPressed: _togglePasswordVisibility,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) => SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          alignment: Alignment(-1.0, 0),
          child: child,
        ),
        child:
            widget.showPasswordIcon != null && widget.hidePasswordIcon != null
            ? SvgPicture.asset(
                _isPasswordVisible
                    ? widget.showPasswordIcon!
                    : widget.hidePasswordIcon!,
                key: ValueKey<bool>(_isPasswordVisible),
                colorFilter: ColorFilter.mode(
                  AppColors.gray3F,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                key: ValueKey<bool>(_isPasswordVisible),
                color: AppColors.gray3F,
                size: 20,
              ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  TextStyle get _resolvedTextStyle {
    final base = widget.textStyle ?? 16.regular;
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

  void _updatePasswordConditions(String value) {
    if (value.contains(RegExp(r'[a-z]'))) {
      passwordConditionsState[0] = true;
    } else {
      passwordConditionsState[0] = false;
    }

    if (value.contains(RegExp(r'[A-Z]'))) {
      passwordConditionsState[1] = true;
    } else {
      passwordConditionsState[1] = false;
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      passwordConditionsState[2] = true;
    } else {
      passwordConditionsState[2] = false;
    }
    if (value.contains(RegExp(r'[!@#\$&*~]'))) {
      passwordConditionsState[3] = true;
    } else {
      passwordConditionsState[3] = false;
    }
    if (value.length > 6 && value.length < 30) {
      passwordConditionsState[4] = true;
    } else {
      passwordConditionsState[4] = false;
    }

    setState(() {});
  }
}
