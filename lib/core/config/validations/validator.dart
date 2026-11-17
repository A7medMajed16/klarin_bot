import 'package:easy_localization/easy_localization.dart';

class Validator {
  final List<String? Function(String)> _rules = [];

  Validator._(String? Function(String) firstRule) {
    _rules.add(firstRule);
  }

  /// Starts with a required check
  static Validator required(String errorKey) =>
      Validator._((v) => v.isEmpty ? errorKey.tr() : null);

  Validator minLength(int n, String errorKey) =>
      this.._rules.add((v) => v.length < n ? errorKey.tr() : null);

  Validator maxLength(int n, String errorKey) =>
      this.._rules.add((v) => v.length > n ? errorKey.tr() : null);

  Validator lengthRange(int min, int max, String errorKey) =>
      this.._rules.add(
        (v) => v.length < min || v.length > max ? errorKey.tr() : null,
      );

  Validator regex(RegExp pattern, String errorKey) =>
      this.._rules.add((v) => !pattern.hasMatch(v) ? errorKey.tr() : null);

  Validator match(String? Function() getValue, String errorKey) =>
      this.._rules.add((v) => v != getValue() ? errorKey.tr() : null);

  Validator exactLength(int n, String errorKey) =>
      this.._rules.add((v) => v.length != n ? errorKey.tr() : null);

  /// Returns validator compatible with TextFormField
  String? Function(String?) build() => (value) {
    if (value == null || value.isEmpty) return _rules.first(value ?? '');
    for (final rule in _rules.skip(1)) {
      final error = rule(value);
      if (error != null) return error;
    }
    return null;
  };
}
