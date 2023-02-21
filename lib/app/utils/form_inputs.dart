import 'package:formz/formz.dart';
import 'package:get/get.dart';

enum ValidationError {
  empty(errorText: "This is a required field"),
  invalidEmail(errorText: "Invalid email format"),
  passwordTooShort(errorText: "Password is too short"),
  passwordNotMatch(errorText: "Passwords don't match");

  final String errorText;
  const ValidationError({required this.errorText});
}

class EmailInput extends FormzInput<String, ValidationError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return pure
        ? null
        : value.isEmpty
            ? ValidationError.empty
            : !value.isEmail
                ? ValidationError.invalidEmail
                : null;
  }
}

class PasswordInput extends FormzInput<String, ValidationError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return pure
        ? null
        : value.isEmpty
            ? ValidationError.empty
            : value.length < 6
                ? ValidationError.passwordTooShort
                : null;
  }
}
