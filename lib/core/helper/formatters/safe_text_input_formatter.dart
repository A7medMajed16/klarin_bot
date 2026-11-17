import 'package:flutter/services.dart';

/// Fixes a known iOS + custom-OTF paste bug where ASCII bytes are expanded
/// into U+XX00 code points (e.g. `'5'` → `U+3500` / `㔀`).
///
/// Also normalizes common digit scripts (Arabic-Indic, Persian, fullwidth) to
/// Latin digits. Non-digit / non-corrupted characters pass through unchanged
/// unless [digitsOnly] is true.
class SafeTextInputFormatter extends TextInputFormatter {
  const SafeTextInputFormatter({
    this.digitsOnly = false,
    this.allowPlus = false,
  });

  final bool digitsOnly;
  final bool allowPlus;

  /// Digit fields (PIN, card pin, OTP, amounts without decimal).
  static const digits = SafeTextInputFormatter(digitsOnly: true);

  /// Phone fields: digits and optional leading `+`.
  static const phone = SafeTextInputFormatter(
    digitsOnly: true,
    allowPlus: true,
  );

  /// All text fields: only repair the iOS `U+XX00` paste corruption.
  static const repair = SafeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final buffer = StringBuffer();
    for (final codeUnit in newValue.text.codeUnits) {
      final fixed = _fixCodeUnit(codeUnit);
      if (fixed == null) continue;
      buffer.writeCharCode(fixed);
    }

    final text = buffer.toString();
    if (text == newValue.text) return newValue;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  }

  int? _fixCodeUnit(int codeUnit) {
    // Recover ASCII expanded as U+XX00 (iOS custom font paste corruption).
    if ((codeUnit & 0xFF) == 0 && codeUnit >= 0x2000 && codeUnit <= 0x7E00) {
      final ascii = codeUnit >> 8;
      if (ascii >= 0x20 && ascii <= 0x7E) {
        return _filterAscii(ascii);
      }
    }

    // Fullwidth digits ０-９
    if (codeUnit >= 0xFF10 && codeUnit <= 0xFF19) {
      return 0x30 + (codeUnit - 0xFF10);
    }

    // Arabic-Indic digits ٠-٩
    if (codeUnit >= 0x0660 && codeUnit <= 0x0669) {
      return 0x30 + (codeUnit - 0x0660);
    }

    // Extended Arabic-Indic (Persian) ۰-۹
    if (codeUnit >= 0x06F0 && codeUnit <= 0x06F9) {
      return 0x30 + (codeUnit - 0x06F0);
    }

    return _filterAscii(codeUnit);
  }

  int? _filterAscii(int codeUnit) {
    if (!digitsOnly) return codeUnit;
    if (codeUnit >= 0x30 && codeUnit <= 0x39) return codeUnit;
    if (allowPlus && codeUnit == 0x2B) return codeUnit;
    return null;
  }
}
