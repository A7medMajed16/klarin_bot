import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/extensions/widgets_extensions.dart';
import '../../../theme/app_assets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';
import '../../../helper/formatters/phone_length_helper.dart';
import 'custom_input_border.dart';

class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({
    super.key,
    this.validator,
    this.controller,
    this.onFieldSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.onSaved,
    this.showTitle = true,
    this.initialCountryCode = '20',
    this.textInputAction = TextInputAction.next,
    this.downArrowIcon,
    this.phoneIcon,
  });
  final String? Function(String? value, int? maxLength)? validator;
  final TextEditingController? controller;
  final void Function(String? value)? onFieldSubmitted;
  final void Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;
  final void Function()? onEditingComplete;
  final bool showTitle;
  final String initialCountryCode;
  final TextInputAction? textInputAction;
  final String? downArrowIcon;
  final String? phoneIcon;

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late TextEditingController _controller;
  int? _maxLength;
  late FocusNode _focusNode;
  late FocusNode _dropdownFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.initializeCountryCode(widget.initialCountryCode);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    _dropdownFocusNode = FocusNode(skipTraversal: true);

    _updateMaxLength();
  }

  void _updateMaxLength() {
    setState(() {
      _maxLength = PhoneLengthHelper
          .countryPhoneLengths[_controller.selectedCountryCode];
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.clearCountryCode();
      _controller.dispose();
    }
    _focusNode.dispose();
    _dropdownFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryCodes = PhoneLengthHelper.countryPhoneLengths.keys.toList();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        obscuringCharacter: "*",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: widget.onSaved,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        onTapOutside: (pos) {
          FocusScope.of(context).unfocus();
        },
        autofocus: false,
        maxLength: _focusNode.hasFocus ? _maxLength : null,
        validator: (value) => widget.validator?.call(value, _maxLength),
        focusNode: _focusNode,
        controller: _controller,
        maxLines: 1,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
        cursorColor: AppWidgetTheme.textFieldCursorColor,
        style: 16.regular,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          hoverColor: Colors.transparent,
          hintText: "custom_widget.phone_number_hint".tr(),
          hintStyle: 14.light.copyWith(
            color: AppWidgetTheme.textFieldHintColor,
          ),
          contentPadding: REdgeInsetsDirectional.only(
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

          suffixIcon: DropdownButton<String>(
            value: _controller.selectedCountryCode,
            focusNode: _dropdownFocusNode,
            borderRadius: BorderRadius.circular(14),
            menuMaxHeight: 0.7.sh,
            menuWidth: 0.15.sw.clamp(150, 200),
            padding: EdgeInsetsDirectional.only(end: 12),
            alignment: AlignmentDirectional.centerEnd,
            elevation: 16,
            // icon: Padding(
            //   padding: const EdgeInsetsDirectional.only(start: 5),
            //   child: Icon(
            //     Icons.keyboard_arrow_down,
            //     color: AppWidgetTheme.tileIconColor,
            //     size: 20,
            //   ),
            // ),
            underline: SizedBox(),
            items: List.generate(countryCodes.length, (index) {
              String code = countryCodes[index];
              String countryName = PhoneLengthHelper.getCountryTitle(
                code,
                context.locale.languageCode,
              );
              return DropdownMenuItem<String>(
                value: code,
                child: Text(
                  '$countryName +$code',
                  style: 12.light.copyWith(
                    color: AppWidgetTheme.textFieldHintColor,
                  ),
                ),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _controller.updateSelectedCountryCode(value);
                  _updateMaxLength();
                });
              }
            },
          ),

          prefixIcon: AppAssets.icons.phone.svg(
            width: 20,
            fit: .scaleDown,
            colorFilter: ColorFilter.mode(
              AppWidgetTheme.textFieldPrefixIconColor,
              BlendMode.srcIn,
            ),
          ),
          errorBorder: customOutLineBorders(borderColor: AppColors.originalRed),
          disabledBorder: customOutLineBorders(),
          border: customOutLineBorders(),
          enabledBorder: customOutLineBorders(),
          focusedBorder: customOutLineBorders(
            borderColor: AppColors.primerColor,
            borderWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
