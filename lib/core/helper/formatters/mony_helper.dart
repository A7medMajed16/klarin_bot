import 'package:easy_localization/easy_localization.dart';

abstract class MonyHelper {
  static String formatMoney({
    required double amount,
    bool showCurrency = true,
    bool showNumberAfterDot = true,
  }) {
    String result;

    if (amount.abs() >= 1000000) {
      final millions = amount / 1000000;
      String numStr = millions.toStringAsFixed(3);
      if (numStr.contains('.')) {
        numStr = numStr
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
      result = '${numStr}M';
    } else {
      String numStr = amount.toStringAsFixed(
        showNumberAfterDot ? 2 : 0,
      );
      if (numStr.contains('.')) {
        numStr = numStr
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
      result = numStr;
      if (amount > 999) {
        String separator = ',';
        RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        result = numStr.replaceAllMapped(
          reg,
          (Match m) => '${m[1]}$separator',
        );
      }
    }

    if (showCurrency) {
      return "$result  ${"global.iq".tr()}";
    }
    return result;
  }

  static String formateNumbers({required String number}) {
    String arabicDigits = number.replaceAllMapped(RegExp(r'\d'), (
      Match m,
    ) {
      const arabicIndicDigits = [
        '٠',
        '١',
        '٢',
        '٣',
        '٤',
        '٥',
        '٦',
        '٧',
        '٨',
        '٩',
      ];
      return arabicIndicDigits[int.parse(m[0]!)];
    });
    return "$arabicDigits ";
  }

  static String formatPoints({required int points}) {
    return NumberFormat('#,###', 'en').format(points);
  }
}
