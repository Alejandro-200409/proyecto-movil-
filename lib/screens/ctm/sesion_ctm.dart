import 'package:flutter/material.dart';

import '../../models/sesion/sesion.dart';
import '../../routes/app_routes.dart';







extension NombreSesionCtm on Sesion {
  
  
  String? get nombreRegistrado {
    final nombres = this.nombres?.trim();
    if (nombres != null && nombres.isNotEmpty) return nombres;

    final usuario = username?.trim();
    if (usuario == null || usuario.isEmpty) return null;
    if (usuario == identificacion) return null;
    if (RegExp(r'^\d+$').hasMatch(usuario)) return null;
    return usuario;
  }

  
  String get etiquetaRol => switch (rol) {
    Rol.gerente => 'Gerente',
    Rol.asistente => 'Asistente',
    Rol.asociado => 'Asociado',
    Rol.desconocido => 'Usuario',
  };

  
  String get nombreVisible => nombreRegistrado ?? etiquetaRol;

  
  String get inicialesVisible {
    final nombre = nombreRegistrado;
    if (nombre == null) return etiquetaRol.substring(0, 1).toUpperCase();
    final partes = nombre
        .split(RegExp(r'\s+'))
        .where((String parte) => parte.isNotEmpty)
        .toList(growable: false);
    if (partes.isEmpty) return '?';
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }
}


void volverASeleccionRol(BuildContext context, Sesion sesion) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    AppRoutes.home,
    (_) => false,
    arguments: sesion,
  );
}


void abrirPanelCtm(BuildContext context, String ruta, Sesion sesion) {
  Navigator.of(context).pushReplacementNamed(ruta, arguments: sesion);
}
