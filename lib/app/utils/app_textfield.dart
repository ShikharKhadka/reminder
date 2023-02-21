import 'package:flutter/material.dart';
import 'package:reminder/app/utils/form_inputs.dart';

import 'app_theme.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onValidate;
  final ValueChanged<String>? onField;
  final ValidationError? validationError;
  final TextEditingController? controller;
  final String? currentValue;
  final String? errorText;

  const AppTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.onChanged,
      this.validationError,
      this.currentValue,
      this.errorText,
      this.onField,
      this.onValidate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: currentValue,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: AppTheme.textfieldNameColor),
          hintText: hintText,
          errorText: errorText,
          // validationError == null ? null : validationError!.errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: onChanged,
        onFieldSubmitted: onField);
  }
}
