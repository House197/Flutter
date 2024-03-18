import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool? obscureText;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.obscureText,
  });
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        label: label != null ? Text(label!) : null,
        hintText: hint,
        errorText: errorMessage,
      ),
      validator: validator,
    );
  }
}
