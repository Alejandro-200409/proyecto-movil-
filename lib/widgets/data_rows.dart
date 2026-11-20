import 'package:flutter/material.dart';

import '../config/app_theme.dart';





class Etiqueta extends StatelessWidget {
  const Etiqueta(this.texto, {required this.color, super.key});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      texto,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        height: 1.1,
      ),
    ),
  );
}


class DatoFila extends StatelessWidget {
  const DatoFila(this.icon, this.texto, {super.key});

  final IconData icon;
  final String texto;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 15, color: AppTheme.muted),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          texto,
          style: const TextStyle(color: AppTheme.dark, fontSize: 13),
        ),
      ),
    ],
  );
}


class CampoDetalle extends StatelessWidget {
  const CampoDetalle(this.icon, this.etiqueta, this.valor, {super.key});

  final IconData icon;
  final String etiqueta;
  final String? valor;

  @override
  Widget build(BuildContext context) {
    final texto = valor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.muted),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                ),
                const SizedBox(height: 1),
                Text(
                  texto == null || texto.isEmpty ? '—' : texto,
                  style: const TextStyle(
                    color: AppTheme.dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class AvisoAccion extends StatelessWidget {
  const AvisoAccion(
    this.texto, {
    required this.onAccion,
    this.etiquetaAccion = 'Reintentar',
    this.habilitado = true,
    super.key,
  });

  final String texto;
  final VoidCallback onAccion;
  final String etiquetaAccion;
  final bool habilitado;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
    decoration: BoxDecoration(
      color: AppTheme.redBg,
      borderRadius: BorderRadius.circular(AppTheme.radioControl),
      border: Border.all(color: AppTheme.redBorder),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, size: 17, color: AppTheme.red),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 12, color: AppTheme.red),
          ),
        ),
        TextButton(
          onPressed: habilitado ? onAccion : null,
          style: TextButton.styleFrom(foregroundColor: AppTheme.red),
          child: Text(etiquetaAccion),
        ),
      ],
    ),
  );
}
