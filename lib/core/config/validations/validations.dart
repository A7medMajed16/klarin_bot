import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'validator.dart';

class Validations {
  Validations._();

  /// Generic required validator — for any field that only needs null/empty check.
  /// Usage: validator: Validations.required('validations.name_required')
  static String? Function(String?) required(String errorKey) =>
      Validator.required(errorKey).build();

  /// Password with full strength rules
  static String? Function(String?) get password =>
      Validator.required('validations.password_required')
          .regex(RegExp(r'[a-z]'), 'validations.set_password_1_condition_error')
          .regex(RegExp(r'[A-Z]'), 'validations.set_password_2_condition_error')
          .regex(RegExp(r'[0-9]'), 'validations.set_password_3_condition_error')
          .regex(
            RegExp(r'[!@#\$%\^&\*\(\)_\-\+=\[\]\{\};:,<>\./\\|~`]'),
            'validations.set_password_4_condition_error',
          )
          .lengthRange(6, 30, 'validations.set_password_5_condition_error')
          .build();

  /// Confirm password (matches another value)
  static String? Function(String?) confirmPassword(String? password) =>
      Validator.required('validations.confirm_password')
          .match(() => password, 'validations.confirm_password_invalid')
          .build();

  /// Phone number with min length, compatible with CustomPhoneField
  static String? Function(String?, int?) get phone =>
      (value, maxLength) => Validator.required('validations.phone_required')
          .minLength(maxLength ?? 0, 'validations.phone_invalid')
          .build()(value);

  /// OTP pin (exactly 6 digits)
  static String? Function(String?) get pin =>
      Validator.required('validations.pin_required')
          .exactLength(6, 'validations.pin_invalid')
          .build();

  /// Email with format validation
  static String? Function(String?) get email =>
      Validator.required('validations.email_required')
          .regex(
            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
            'validations.email_invalid',
          )
          .build();

  /// Profile image (standalone — not String-based)
  static String? validateUserImage(File? value) {
    if (value == null) return 'validations.profile_image'.tr();
    return null;
  }
}
