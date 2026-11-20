import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_theme.dart';



class ProtoField extends StatefulWidget {
  const ProtoField({
    required this.label,
    this.controller,
    this.hintText,
    this.esPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autocorrect = true,
    this.icono,
    this.forzarVisible,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;

  
  final bool esPassword;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  
  final bool enabled;

  final int maxLines;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;

  
  final IconData? icono;

  
  
  final bool? forzarVisible;

  @override
  State<ProtoField> createState() => _ProtoFieldState();
}

class _ProtoFieldState extends State<ProtoField> {
  bool _oculto = true;

  @override
  void initState() {
    super.initState();
    _oculto = widget.esPassword;
  }

  OutlineInputBorder _borde(Color color, double ancho) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppTheme.radioControl),
    borderSide: BorderSide(color: color, width: ancho),
  );

  
  bool get _oculta => widget.forzarVisible == true ? false : _oculto;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.dark,
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: widget.esPassword && _oculta,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        autocorrect: widget.autocorrect,
        enableSuggestions: !widget.esPassword,
        maxLines: widget.esPassword ? 1 : widget.maxLines,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        style: const TextStyle(fontSize: 13, color: AppTheme.dark),
        cursorColor: AppTheme.primary,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: widget.enabled ? Colors.white : AppTheme.gray,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 13, color: AppTheme.muted),
          prefixIcon: widget.icono == null
              ? null
              : Icon(widget.icono, size: 18, color: AppTheme.muted),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.icono == null ? 14 : 4,
            vertical: widget.maxLines > 1 ? 12 : 13,
          ),
          border: _borde(AppTheme.border, 1),
          enabledBorder: _borde(AppTheme.border, 1),
          disabledBorder: _borde(AppTheme.border, 1),
          focusedBorder: _borde(AppTheme.primary, 1.4),
          errorBorder: _borde(AppTheme.red, 1),
          focusedErrorBorder: _borde(AppTheme.red, 1.2),
          errorStyle: const TextStyle(fontSize: 10, color: AppTheme.red),
          suffixIcon: widget.esPassword ? _ojo() : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ),
    ],
  );

  Widget _ojo() => IconButton(
    tooltip: _oculta ? 'Mostrar contraseña' : 'Ocultar contraseña',
    onPressed: () => setState(() => _oculto = !_oculto),
    padding: EdgeInsets.zero,
    iconSize: 18,
    color: AppTheme.muted,
    style: IconButton.styleFrom(
      minimumSize: const Size(40, 40),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    icon: Icon(
      _oculta ? Icons.visibility_outlined : Icons.visibility_off_outlined,
    ),
  );
}
