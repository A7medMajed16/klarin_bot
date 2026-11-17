import 'package:material_ui/material_ui.dart';

enum LanguageType { arabic }

const String arabic = 'ar';

const String assetsLocalization = 'lib/core/localization';

const Locale arabicLocale = Locale("ar", "EG");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.arabic:
        return arabic;
    }
  }
}
