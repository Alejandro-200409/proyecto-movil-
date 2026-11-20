import 'package:flutter/material.dart';

import '../../config/app_theme.dart';



class ProtoSectionLabel extends StatelessWidget {
  const ProtoSectionLabel({
    required this.texto,
    this.cargando = false,
    super.key,
  });

  final String texto;

  
  final bool cargando;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        texto.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.dark,
          letterSpacing: 0.9,
        ),
      ),
      if (cargando) ...[
        const SizedBox(width: 8),
        const SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(strokeWidth: 1.6),
        ),
      ],
      const SizedBox(width: 10),
      Expanded(child: Container(height: 1, color: AppTheme.rule)),
    ],
  );
}
