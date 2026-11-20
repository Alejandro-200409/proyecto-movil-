import 'package:flutter/material.dart';

import '../../config/app_theme.dart';


enum ProtoBotonVariante { primario, secundario, peligro }





class ProtoButton extends StatelessWidget {
  const ProtoButton({
    required this.label,
    this.onPressed,
    this.variante = ProtoBotonVariante.primario,
    this.full = true,
    this.cargando = false,
    this.icono,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final ProtoBotonVariante variante;

  
  final bool full;

  
  final bool cargando;
  final IconData? icono;

  Color get _fondo => switch (variante) {
    ProtoBotonVariante.primario => AppTheme.primary,
    ProtoBotonVariante.secundario => Colors.white,
    ProtoBotonVariante.peligro => AppTheme.red,
  };

  Color get _texto => switch (variante) {
    ProtoBotonVariante.primario => Colors.white,
    ProtoBotonVariante.secundario => AppTheme.dark,
    ProtoBotonVariante.peligro => Colors.white,
  };

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    width: full ? double.infinity : null,
    child: FilledButton(
      onPressed: cargando ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _fondo,
        foregroundColor: _texto,
        disabledBackgroundColor: variante == ProtoBotonVariante.secundario
            ? AppTheme.gray
            : AppTheme.mentaFuerte,
        disabledForegroundColor: variante == ProtoBotonVariante.secundario
            ? AppTheme.muted
            : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 46),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: variante == ProtoBotonVariante.secundario
            ? const BorderSide(color: AppTheme.border)
            : BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radioControl),
        ),
        textStyle: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: _contenido(),
    ),
  );

  Widget _contenido() {
    if (cargando) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: _texto),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        if (icono != null) ...[const SizedBox(width: 7), Icon(icono, size: 16)],
      ],
    );
  }
}
