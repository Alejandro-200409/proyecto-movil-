import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/app_theme.dart';
import '../../models/catalogo/catalogo_ctm.dart';





class IconosCtm {
  IconosCtm._();

  static const String _base = 'assets/images/ctm';

  static const String menu = '$_base/menu.svg';
  static const String inicio = '$_base/inicio.svg';
  static const String viajes = '$_base/viajes.svg';
  static const String turno = '$_base/turno.svg';
  static const String gestion = '$_base/gestion.svg';
  static const String ruta = '$_base/ruta.svg';
  static const String info = '$_base/info.svg';
  static const String camioneta = '$_base/camioneta.svg';
  static const String buseta = '$_base/buseta.svg';
  static const String flete = '$_base/flete.svg';
  static const String expreso = '$_base/expreso.svg';
  static const String logo = '$_base/logo.png';
  static const String mapaBusqueda = '$_base/mapa_busqueda.svg';
  static const String mapaViaje = '$_base/mapa_viaje.svg';
  static const String mapaRecibo = '$_base/mapa_recibo.png';

  
  static String deTransporte(IconoTransporte icono) => switch (icono) {
    IconoTransporte.camioneta => camioneta,
    IconoTransporte.buseta => buseta,
    IconoTransporte.flete => flete,
    IconoTransporte.expreso => expreso,
  };
}


class IconoCtm extends StatelessWidget {
  const IconoCtm(
    this.ruta, {
    this.ancho,
    this.alto,
    this.color,
    super.key,
  });

  final String ruta;
  final double? ancho;
  final double? alto;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      ruta,
      width: ancho,
      height: alto,
      fit: BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}


class LogoCtm extends StatelessWidget {
  const LogoCtm({this.lado = 82, this.padding = 10, super.key});

  final double lado;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lado,
      height: lado,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.divisor),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1F0A3B24),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Image.asset(IconosCtm.logo, fit: BoxFit.contain),
    );
  }
}
