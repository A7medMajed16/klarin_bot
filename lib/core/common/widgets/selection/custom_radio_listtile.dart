import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';

class CustomRadioListtile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String? title, icon;
  final Color? tileColor;
  final double radius;
  final AlignmentGeometry titleAlignment;
  const CustomRadioListtile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.icon,
    this.tileColor = AppWidgetTheme.tileBackgroundColor,
    this.radius = 12,
    this.titleAlignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    return Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: () => onChanged(value),
        hoverColor: AppWidgetTheme.tileHoverColor,
        splashColor: AppWidgetTheme.tileSplashColor,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            spacing: 8,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    icon!,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppWidgetTheme.tileIconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              Expanded(
                child: Align(
                  alignment: titleAlignment,
                  child: Text(
                    title ?? "",
                    style: 14.regular.copyWith(
                      color: AppColors.gray71,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 4),
                curve: Curves.easeInOut,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primerColor
                        : AppWidgetTheme.textFieldBorderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                    child: isSelected
                        ? Container(
                            key: ValueKey('selected'),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primerGradient,
                            ),
                          )
                        : SizedBox(
                            key: ValueKey('unselected'),
                            width: 8,
                            height: 8,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
