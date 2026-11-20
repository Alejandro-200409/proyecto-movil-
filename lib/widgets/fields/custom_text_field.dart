import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.autocorrect = true,
    this.enabled = true,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autocorrect;

  
  
  final bool enabled;

  
  final int maxLines;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    autocorrect: autocorrect,
    enabled: enabled,
    maxLines: maxLines,
    textCapitalization: textCapitalization,
    onFieldSubmitted: onFieldSubmitted,
    inputFormatters: inputFormatters,
    style: const TextStyle(fontSize: 13, color: AppTheme.dark),
    cursorColor: AppTheme.primary,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: enabled ? Colors.white : AppTheme.gray,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioControl),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioControl),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioControl),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioControl),
        borderSide: const BorderSide(color: AppTheme.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioControl),
        borderSide: const BorderSide(color: AppTheme.red, width: 1.2),
      ),
    ),
    validator: validator,
  );
}
