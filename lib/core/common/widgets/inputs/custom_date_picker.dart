import 'package:material_ui/material_ui.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_widget_theme.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  String? hint,
  String? title,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? initialDate,
  bool withTime = false,
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: initialDate ?? DateTime.now(),
    fieldHintText: hint,
    fieldLabelText: title,
    initialEntryMode: DatePickerEntryMode.calendar,
    builder: (BuildContext context, Widget? picker) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          dividerTheme: const DividerThemeData(
            color: Colors.transparent,
          ),
          colorScheme: const ColorScheme.light(
            primary: AppColors.primerColor,
            onPrimary: AppColors.originalWhite,
            onSurface: AppWidgetTheme.datePickerTextColor,
          ),
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primerColor,
            ),
          ),
        ),
        child: picker!,
      );
    },
  );

  if (pickedDate == null) return null;

  if (!withTime) return pickedDate;

  final TimeOfDay initialTime = initialDate != null
      ? TimeOfDay(hour: initialDate.hour, minute: initialDate.minute)
      : TimeOfDay.now();

  final TimeOfDay? pickedTime = context.mounted
      ? await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primerColor,
                  onPrimary: AppColors.originalWhite,
                  onSurface: AppWidgetTheme.datePickerTextColor,
                ),
                timePickerTheme: TimePickerThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primerColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        )
      : null;

  if (pickedTime == null) return pickedDate;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}

class CustomDatePicker extends StatelessWidget {
  final String? confirmText;
  final String hintText;
  final String? value;
  final Color borderColor;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final double borderRadius;
  final Function(DateTime? selectedDate)? onDateSelected;
  final bool withTime;
  const CustomDatePicker({
    super.key,
    this.confirmText,
    required this.hintText,
    this.onDateSelected,
    this.value,
    this.borderColor = AppWidgetTheme.textFieldBorderColor,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.borderRadius = 8,
    this.withTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDateSelected != null
          ? () async {
              DateTime? selectedDate = await showCustomDatePicker(
                context: context,
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? DateTime.now(),
                initialDate: initialDate,
                withTime: withTime,
              );
              if (selectedDate != null && onDateSelected != null) {
                onDateSelected!(selectedDate);
              }
            }
          : null,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.originalWhite,
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                value ?? hintText,
                style: 14.light.copyWith(
                  color: value != null
                      ? AppWidgetTheme.textFieldTitleColor
                      : AppWidgetTheme.textFieldHintColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppWidgetTheme.datePickerIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
