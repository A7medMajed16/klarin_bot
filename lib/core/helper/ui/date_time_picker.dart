import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class DateTimePicker {
  static Future<DateTimeRange?> pickDateRange({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    Locale? locale,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final bool isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primerColor,
              onPrimary: AppColors.originalWhite,
              onSurface: AppColors.black27,
              secondary: AppColors.primerColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primerColor,
              ),
            ),
          ),
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24.w : 0,
              vertical: 24.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColors.originalWhite,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: isMobile ? double.infinity : 400.w,
              height: isMobile ? 520.h : 600.w,
              child: DateRangePickerDialog(
                initialDateRange: initialDateRange,
                firstDate:
                    firstDate ??
                    DateTime.now().subtract(const Duration(days: 365)),
                lastDate:
                    lastDate ?? DateTime.now().add(const Duration(days: 365)),
                helpText: helpText,
                cancelText: cancelText,
                confirmText: confirmText,
                switchToInputEntryModeIcon: const Icon(
                  Icons.edit_calendar_rounded,
                ),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              ),
            ),
          ),
        );
      },
    );
  }
}
