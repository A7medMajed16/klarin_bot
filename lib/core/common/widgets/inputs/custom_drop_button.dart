import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';
import '../../../theme/scroll_bar_theme.dart';
import '../../../utils/constants/app_strings.dart';
import '../inputs/custom_text_field.dart';

class CustomDropButton extends StatefulWidget {
  const CustomDropButton({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint,
    this.validator,
    this.withUpdate = true,
    this.headerTextStyle,
    this.spacing = 0,
    this.radius = 8,
    this.borderColor = AppWidgetTheme.textFieldBorderColor,
    this.height,
    this.enabled = true,
    this.icon,
    this.recolorIcon = true,
    this.preferLazyModal = false,
    this.enableSearchInModal = false,
    this.searchHint,
    this.isWeb = false,
    this.downArrowIcon,
    this.searchIcon,
  });
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String? selectedValue)? onChanged;
  final String? hint, icon;
  final String? Function(dynamic value)? validator;
  final bool withUpdate, enabled, recolorIcon, isWeb;
  final double? spacing, radius, height;
  final TextStyle? headerTextStyle;
  final Color borderColor;

  final bool preferLazyModal;
  final bool enableSearchInModal;
  final String? searchHint;
  final String? downArrowIcon;
  final String? searchIcon;

  @override
  State<CustomDropButton> createState() => _CustomDropButtonState();
}

class _CustomDropButtonState extends State<CustomDropButton> {
  String? _localValue;

  @override
  void didUpdateWidget(covariant CustomDropButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  String? _labelForValue(String? v) {
    if (v == null) return null;
    for (final item in widget.items) {
      if (item.value == v) {
        final child = item.child;
        if (child is Text) return child.data;
      }
    }
    return v;
  }

  Future<void> _openModalPicker() async {
    if (!widget.enabled) return;
    final selectedBefore = _localValue ?? widget.value;
    String? result;

    if (widget.isWeb && widget.preferLazyModal) {
      result = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        barrierColor: AppWidgetTheme.barrierColor,
        builder: (ctx) {
          List<DropdownMenuItem<String>> filtered = widget.items;
          final controller = TextEditingController();
          return StatefulBuilder(
            builder: (context, setSB) {
              final size = MediaQuery.of(context).size;
              double dialogWidth = size.width * 0.9;
              if (dialogWidth > 640) dialogWidth = 640;
              double dialogHeight = size.height * 0.85;
              if (dialogHeight > 560) dialogHeight = 560;
              return AlertDialog(
                backgroundColor: AppColors.originalWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: AppWidgetTheme.textFieldBorderColor),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  width: dialogWidth,
                  height: dialogHeight,
                  child: Column(
                    children: [
                      if (widget.enableSearchInModal)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CustomTextFormField(
                            controller: controller,
                            hintText:
                                widget.searchHint ??
                                "custom_widget.search".tr(),
                            suffixWidget: widget.searchIcon != null
                                ? SvgPicture.asset(
                                    widget.searchIcon!,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Icon(
                                    Icons.search,
                                    size: 24,
                                    color: AppWidgetTheme.tileIconColor,
                                  ),
                            textDirection: TextDirection.ltr,

                            onChanged: (q) {
                              final query = q!.trim().toLowerCase();
                              setSB(() {
                                filtered = widget.items.where((e) {
                                  final w = e.child;
                                  String text = '';
                                  if (w is Text) {
                                    text = w.data ?? '';
                                  } else {
                                    text = e.value ?? '';
                                  }
                                  return text.toLowerCase().contains(query);
                                }).toList();
                              });
                            },
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ScrollConfiguration(
                            behavior: NoScrollbarBehavior(),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final isSelected =
                                      item.value == selectedBefore;
                                  return ListTile(
                                    title: item.child,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    selectedTileColor:
                                        AppWidgetTheme.selectedTileColor,
                                    selected: isSelected,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onTap: () => context.router.canPop()
                                        ? context.pop(item.value)
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      result = await showModalBottomSheet<String>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: AppColors.originalWhite,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          List<DropdownMenuItem<String>> filtered = widget.items;
          final controller = TextEditingController();
          return StatefulBuilder(
            builder: (context, setSB) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.6,
                maxChildSize: 0.9,
                minChildSize: 0.4,
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      if (widget.enableSearchInModal)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CustomTextFormField(
                            controller: controller,
                            hintText:
                                widget.searchHint ??
                                "custom_widget.search".tr(),
                            prefixIcon: widget.searchIcon,
                            onChanged: (q) {
                              final query = q!.trim().toLowerCase();
                              setSB(() {
                                filtered = widget.items.where((e) {
                                  final w = e.child;
                                  String text = '';
                                  if (w is Text) {
                                    text = w.data ?? '';
                                  } else {
                                    text = e.value ?? '';
                                  }
                                  return text.toLowerCase().contains(query);
                                }).toList();
                              });
                            },
                          ),
                        ),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ScrollConfiguration(
                              behavior: NoScrollbarBehavior(),
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final isSelected =
                                      item.value == selectedBefore;
                                  return ListTile(
                                    title: item.child,
                                    selectedTileColor:
                                        AppWidgetTheme.selectedTileColor,
                                    selected: isSelected,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onTap: () => context.router.canPop()
                                        ? context.pop(item.value)
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }
    setState(() => _localValue = result);
    widget.onChanged?.call(result);
  }

  InputDecoration _decoration() {
    return InputDecoration(
      prefixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      fillColor: widget.enabled
          ? AppColors.originalWhite
          : AppWidgetTheme.textFieldDisabledFillColor,
      filled: true,
      focusColor: AppColors.originalWhite,
      errorStyle: TextStyle(
        fontFamily: AppStrings.arabicFontFamily,
        color: AppWidgetTheme.textFieldErrorTextColor,
        fontSize: 12,
      ),
      hoverColor: widget.enabled
          ? AppWidgetTheme.tileHoverColor
          : Colors.transparent,
      errorMaxLines: 4,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
        borderSide: BorderSide(color: AppColors.originalRed, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
        borderSide: BorderSide(color: widget.borderColor, width: 0.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
        borderSide: BorderSide(color: widget.borderColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
        borderSide: const BorderSide(color: AppColors.primerColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentValue = _localValue ?? widget.value;
    final selectedLabel = _labelForValue(currentValue);

    if (!widget.preferLazyModal) {
      return SizedBox(
        height: widget.height,
        child: DropdownButtonFormField(
          items: widget.items,
          key: widget.withUpdate ? null : UniqueKey(),
          initialValue: widget.value,
          menuMaxHeight: 240,
          onChanged: widget.enabled ? widget.onChanged : null,
          isExpanded: true,
          autofocus: false,
          validator: widget.validator,
          alignment: AlignmentDirectional.topStart,
          hint: Text(
            widget.hint ?? "",
            style: 14.light.copyWith(
              color: widget.enabled
                  ? AppWidgetTheme.textFieldHintColor
                  : AppWidgetTheme.textFieldDisabledHintColor,
            ),
          ),

          icon: widget.downArrowIcon != null
              ? SvgPicture.asset(
                  widget.downArrowIcon!,
                  colorFilter: ColorFilter.mode(
                    widget.enabled
                        ? AppWidgetTheme.tileIconColor
                        : AppWidgetTheme.textFieldDisabledHintColor,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.scaleDown,
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.enabled
                      ? AppWidgetTheme.tileIconColor
                      : AppWidgetTheme.textFieldDisabledHintColor,
                ),
          decoration: _decoration(),
          elevation: 9,
          borderRadius: BorderRadius.circular(widget.radius!),
          dropdownColor: AppColors.originalWhite,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          style: TextStyle(
            fontFamily: AppStrings.arabicFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppWidgetTheme.textFieldHintColor,
            height: 1.6,
          ),
        ),
      );
    }

    return FormField<String>(
      validator: widget.validator,
      initialValue: currentValue,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: widget.enabled ? _openModalPicker : null,
              child: InputDecorator(
                isEmpty: (selectedLabel == null || selectedLabel.isEmpty),
                decoration: _decoration(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8.0),
                        child: SvgPicture.asset(
                          widget.icon!,
                          width: 20,
                          height: 20,
                          fit: BoxFit.scaleDown,
                          colorFilter: widget.recolorIcon
                              ? const ColorFilter.mode(
                                  AppWidgetTheme.tileIconColor,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        selectedLabel ?? (widget.hint ?? ''),
                        style: 14.light.copyWith(
                          color: widget.enabled
                              ? AppWidgetTheme.textFieldHintColor
                              : AppWidgetTheme.textFieldDisabledHintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    widget.downArrowIcon != null
                        ? SvgPicture.asset(
                            widget.downArrowIcon!,
                            colorFilter: ColorFilter.mode(
                              widget.enabled
                                  ? AppWidgetTheme.tileIconColor
                                  : AppWidgetTheme.textFieldDisabledHintColor,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.scaleDown,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down,
                            color: widget.enabled
                                ? AppWidgetTheme.tileIconColor
                                : AppWidgetTheme.textFieldDisabledHintColor,
                          ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, top: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontFamily: AppStrings.arabicFontFamily,
                    color: AppWidgetTheme.textFieldErrorTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
