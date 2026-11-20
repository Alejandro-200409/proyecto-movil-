import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: _obscureText,
    autofillHints: const [AutofillHints.password],
    enableSuggestions: false,
    autocorrect: false,
    textInputAction: TextInputAction.done,
    onFieldSubmitted: widget.onFieldSubmitted,
    style: const TextStyle(fontSize: 13, color: AppTheme.dark),
    cursorColor: AppTheme.primary,
    decoration: InputDecoration(
      labelText: 'Contraseña',
      filled: true,
      fillColor: Colors.white,
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
      suffixIcon: IconButton(
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
        color: AppTheme.muted,
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    ),
    validator: widget.validator,
  );
}
