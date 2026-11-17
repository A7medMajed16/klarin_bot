import 'package:easy_localization/easy_localization.dart';
import 'package:ntp/ntp.dart';
//! OPTIONAL "hijri": requires hijri. Enable it in Automation_dart/init_project_folders.dart.
//#optional:hijri
// import 'package:hijri/hijri_calendar.dart';
//#end-optional:hijri

import '../../cache/storage/cache_helper.dart';

class DateTimeHelper {
  static int _ntpOffsetMs = 0;
  static bool _ntpSynced = false;
  static const List<String> _arabicWeekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];
  static const List<String> _englishWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  //!MARK: GET NOW======================

  static Future<DateTime> get now async => nowSync;

  /// Call once at startup. Safe to call again to refresh.
  static Future<void> syncNtpOffset() async {
    try {
      _ntpOffsetMs = await NTP.getNtpOffset(
        timeout: const Duration(seconds: 5),
      );
      _ntpSynced = true;
    } catch (_) {
      // Keep last known offset / device time on failure.
    }
  }

  /// Synchronous network-corrected now (falls back to device time
  /// until the first successful sync).
  static DateTime get nowSync =>
      DateTime.now().add(Duration(milliseconds: _ntpOffsetMs));

  static bool get isNtpSynced => _ntpSynced;

  /// Parses an API/ISO timestamp and returns local wall time for display.
  /// Use [nowSync] (not [DateTime.now]) when comparing to "now".
  static DateTime parseToLocal(String date) =>
      toLocalDateTime(DateTime.parse(date));

  /// Converts an instant to local time (UTC first so naive UTC strings behave).
  static DateTime toLocalDateTime(DateTime dateTime) =>
      dateTime.toUtc().toLocal();

  //!MARK: FORMAT DATE TIME LOCALIZED====
  static String formatFullDateTimeLocalized(
    String date, {
    bool withTime = true,
  }) {
    final DateTime dateTime = parseToLocal(date);
    final contextLocale = SP.getAppLang();

    final List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    final List<String> englishMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final weekday = formatWeekdayLocalized(dateTime);
    final month = contextLocale == 'ar'
        ? arabicMonths[dateTime.month - 1]
        : englishMonths[dateTime.month - 1];

    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final isAm = dateTime.hour < 12;

    String timePeriod;
    if (contextLocale == 'ar') {
      timePeriod = isAm ? 'ص' : 'م';
    } else {
      timePeriod = isAm ? 'AM' : 'PM';
    }
    final bool isToday =
        dateTime.year == nowSync.year &&
        dateTime.month == nowSync.month &&
        dateTime.day == nowSync.day;
    final String time = '$hour:$minute $timePeriod';
    final String dateString = isToday
        ? contextLocale == 'ar'
              ? 'اليوم'
              : 'Today'
        : withTime
        ? '$weekday، $day $month $year'
        : '$day $month $year';

    if (contextLocale == 'ar') {
      return withTime ? '$dateString ، الساعة $time' : dateString;
    } else {
      return withTime ? '$dateString ، $time' : dateString;
    }
  }

  //!MARK: FORMAT WEEKDAY LOCALIZED======================
  static String formatWeekdayLocalized(DateTime dateTime) {
    final localDate = toLocalDateTime(dateTime);
    final weekdays = SP.getAppLang().startsWith('ar')
        ? _arabicWeekdays
        : _englishWeekdays;
    return weekdays[localDate.weekday - 1];
  }

  //!MARK: LOCALIZE ARABIC COUNTS======================
  static String localizeCount(
    int count, {
    required String singularKey,
    required String dualKey,
    required String pluralKey,
  }) {
    if (count <= 0) return '';
    final isAr = SP.getAppLang().startsWith('ar');

    if (count == 1) {
      return isAr ? singularKey.tr() : '1 ${singularKey.tr()}';
    }

    if (isAr) {
      if (count == 2) {
        return dualKey.tr();
      } else if (count >= 3 && count <= 10) {
        return '$count ${pluralKey.tr()}';
      } else {
        return '$count ${singularKey.tr()}';
      }
    } else {
      return '$count ${pluralKey.tr()}';
    }
  }

  //!MARK: FORMAT DURATION IN MONTHS======================
  static String formatDurationInMonths(int totalMonths) {
    if (totalMonths <= 0) return '';

    final int years = totalMonths ~/ 12;
    final int remainingMonths = totalMonths % 12;

    final List<String> parts = [];
    if (years > 0) {
      parts.add(
        localizeCount(
          years,
          singularKey: 'date_time.year',
          dualKey: 'date_time.two_years',
          pluralKey: 'date_time.years',
        ),
      );
    }

    if (remainingMonths > 0) {
      parts.add(
        localizeCount(
          remainingMonths,
          singularKey: 'date_time.month',
          dualKey: 'date_time.two_months',
          pluralKey: 'date_time.months',
        ),
      );
    }

    final isAr = SP.getAppLang().startsWith('ar');
    return parts.join(isAr ? ' و ' : ' and ');
  }

  //!MARK: TIME AGO FROM NOW======================
  static String timeAgoFromNow(String date) {
    final DateTime dateTime = parseToLocal(date);
    final DateTime now = nowSync;
    Duration diff = now.difference(dateTime);
    if (diff.isNegative) diff = Duration.zero;

    final int years = diff.inDays ~/ 365;
    final int months = (diff.inDays % 365) ~/ 30;
    final int days = (diff.inDays % 365) % 30;
    final int hours = diff.inHours % 24;
    final int minutes = diff.inMinutes % 60;

    final List<String> parts = [];
    if (years > 0) parts.add('$years ${'date_time.year'.tr()}');
    if (months > 0) parts.add('$months ${'date_time.month'.tr()}');
    if (days > 0) {
      parts.add(
        '${days == 1 ? "" : days} ${days == 1 ? 'date_time.day'.tr() : 'date_time.days'.tr()}',
      );
    }
    if (hours > 0) {
      parts.add(
        '$hours ${hours == 1 ? 'date_time.hour'.tr() : 'date_time.hours'.tr()}',
      );
    }
    if (minutes > 0) {
      parts.add(
        '$minutes ${minutes == 1 ? 'date_time.minute'.tr() : 'date_time.minutes'.tr()}',
      );
    }

    if (parts.isEmpty) return 'date_time.just_now'.tr();
    return '${'date_time.from'.tr()} ${parts.join(' ${'date_time.and'.tr()}')}';
  }

  //!MARK: REFORMAT DATE TIME======================
  static String reformatDateTime(String date) {
    final DateTime dateTime = parseToLocal(date);
    final int hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final String period = dateTime.hour < 12
        ? 'date_time.am'.tr()
        : 'date_time.pm'.tr();

    return '${dateTime.toString().split(' ')[0].split('-').reversed.join('/')} '
        '_${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  //!MARK: REFORMAT DATE======================
  static String reformatDate(String date) {
    final DateTime dateTime = parseToLocal(date);

    return dateTime.toString().split(' ')[0].split('-').reversed.join('/');
  }

  //!MARK: REFORMAT DATE LOCALIZED======================
  static String reformatDateLocalized(
    String date, {
    String? locale,
    bool withYear = true,
  }) {
    try {
      final DateTime dateTime = parseToLocal(date);
      final contextLocale = locale ?? SP.getAppLang();
      final day = dateTime.day;
      final year = dateTime.year;

      final List<String> arabicMonths = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];

      final List<String> englishShortMonths = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      if (contextLocale.startsWith('ar')) {
        final month = arabicMonths[dateTime.month - 1];
        return withYear ? '$day $month $year' : '$day $month';
      } else {
        final month = englishShortMonths[dateTime.month - 1];
        return withYear ? '$day $month $year' : '$day $month';
      }
    } catch (_) {
      // Fallback to a simple yyyy-mm-dd -> dd/mm/yyyy format if parsing fails
      try {
        final parts = date.split(' ')[0].split('-');
        if (parts.length >= 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      } catch (_) {}
      return date;
    }
  }

  //!MARK: FORMAT DATE WITH TIME RANGE LOCALIZED=========
  /// Example: الأحد 12 يوليو [ 2:00ص : 3:15ص ]
  static String formatDateWithTimeRangeLocalized(
    DateTime dateTime,
    Duration duration,
  ) {
    final DateTime start = toLocalDateTime(dateTime);
    final DateTime end = start.add(duration);
    final weekday = formatWeekdayLocalized(start);
    final datePart = reformatDateLocalized(
      start.toIso8601String(),
      withYear: false,
    );
    final startTime = _formatTimeRangePart(start);
    final endTime = _formatTimeRangePart(end);

    return '$weekday $datePart [ $startTime : $endTime ]';
  }

  static String _formatTimeRangePart(DateTime dateTime) {
    final int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String period = dateTime.hour < 12
        ? 'date_time.am'.tr()
        : 'date_time.pm'.tr();

    return '$hour:$minute$period';
  }

  //!MARK: REFORMAT TIME REMAINING======================
  static String reformatTimeRemaining(
    String date, {
    bool showDays = true,
    bool showHours = true,
    bool showMinutes = true,
  }) {
    final DateTime dateTime = parseToLocal(date);
    final DateTime now = nowSync;
    final Duration difference = dateTime.difference(now);
    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);
    final List<String> parts = [];
    if (days > 0 && showDays) {
      if (hours > 0 && !showHours) {
        days += 1;
      }
      parts.add(
        "$days ${days == 1 || days == 2 ? "date_time.day".tr() : "date_time.days".tr()}",
      );
    }
    if (hours > 0 && showHours) {
      parts.add(
        "$hours ${hours == 1 || hours == 2 ? "date_time.hour".tr() : "date_time.hours".tr()}",
      );
    }
    if (minutes > 0 && showMinutes) {
      parts.add(
        "$minutes ${minutes == 1 || minutes == 2 ? "date_time.minute".tr() : "date_time.minutes".tr()}",
      );
    }
    return parts.join(' / ');
  }

  //!MARK: REFORMAT DAY REMAINING======================
  static String reformatDayRemaining(String endDate) {
    final DateTime end = DateTime.parse(endDate).toLocal();
    final DateTime now = nowSync;

    if (now.isAfter(end)) return '';

    final int days = end.difference(now).inDays;
    if (days <= 0) return '';

    final String dayWord = (days == 1 || days == 2)
        ? 'date_time.day'.tr()
        : 'date_time.days'.tr();
    return '( متبقي $days $dayWord)';
  }

  //!MARK: REFORMAT TIME LOCALIZED======================
  static String reformatTimeLocalized(String date, {String? locale}) {
    final DateTime dateTime = parseToLocal(date);
    final contextLocale = locale ?? SP.getAppLang();

    return _formatHourMinute12Localized(
      dateTime.hour,
      dateTime.minute,
      contextLocale,
    );
  }

  /// Converts a 24-hour clock string (e.g. `14:30` or `14:30:00`) to localized
  /// 12-hour display. Full ISO timestamps are supported via [parseToLocal].
  static String formatTime24To12Localized(String time24, {String? locale}) {
    final trimmed = time24.trim();
    if (trimmed.isEmpty) return '';

    if (trimmed.contains('T') ||
        (trimmed.contains('-') && trimmed.contains(':'))) {
      return reformatTimeLocalized(trimmed, locale: locale);
    }

    try {
      final parts = trimmed.split(':');
      if (parts.length < 2) return trimmed;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return trimmed;
      }

      return _formatHourMinute12Localized(
        hour,
        minute,
        locale ?? SP.getAppLang(),
      );
    } catch (_) {
      return trimmed;
    }
  }

  static String _formatHourMinute12Localized(
    int hour24,
    int minute,
    String contextLocale,
  ) {
    final int hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final String minuteStr = minute.toString().padLeft(2, '0');
    final bool isAm = hour24 < 12;

    final String period = contextLocale.startsWith('ar')
        ? (isAm ? 'ص' : 'م')
        : (isAm ? 'AM' : 'PM');

    return '${hour12.toString().padLeft(2, '0')}:$minuteStr $period';
  }

  //!MARK: FORMAT TO HIJRI AND GREGORIAN======================
//#optional:hijri
  // static String formatToHijriAndGregorian(String date, {String locale = 'ar'}) {
  //   final DateTime dateTime = parseToLocal(date);

  //   HijriCalendar.setLocal(locale);
  //   final HijriCalendar hijriDate = HijriCalendar.fromDate(dateTime);

  //   final String hijriString =
  //       '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} هـ';

  //   final String gregorianString = DateFormat(
  //     'dd MMMM yyyy',
  //     locale,
  //   ).format(dateTime);

  //   return locale == 'ar'
  //       ? '$hijriString (الموافق $gregorianString م)'
  //       : '$hijriString ($gregorianString)';
  // }
//#end-optional:hijri

  //!MARK: GET REMAINING DAYS======================
  static String getRemainingDays(String date) {
    final DateTime dateTime = parseToLocal(date);
    final DateTime now = nowSync;
    final int days = dateTime.difference(now).inDays;

    if ([3, 4, 5, 6, 7, 8, 9, 10].contains(days)) {
      return '$days ${'date_time.days'.tr()}';
    } else if (days == 1) {
      return 'date_time.day'.tr();
    } else if (days == 2) {
      return 'date_time.two_days'.tr();
    } else {
      return '$days ${'date_time.day'.tr()}';
    }
  }

  //!MARK: GET REMAINING HOURS======================
  static String getRemainingHours(String date) {
    final DateTime dateTime = parseToLocal(date);
    final DateTime now = nowSync;
    final int hours = dateTime.difference(now).inHours;

    if ([3, 4, 5, 6, 7, 8, 9, 10].contains(hours)) {
      return '$hours ${'date_time.hours'.tr()}';
    } else if (hours == 1) {
      return 'date_time.hour'.tr();
    } else if (hours == 2) {
      return 'date_time.two_hours'.tr();
    } else {
      return '$hours ${'date_time.hour'.tr()}';
    }
  }
}
