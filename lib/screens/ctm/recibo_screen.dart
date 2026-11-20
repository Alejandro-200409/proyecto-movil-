import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/sesion/sesion.dart';
import '../../models/solicitud/solicitud_viaje.dart';
import '../../routes/app_routes.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'sesion_ctm.dart';


class ReciboScreen extends StatelessWidget {
  const ReciboScreen({
    required this.sesion,
    required this.solicitud,
    super.key,
  });

  final Sesion sesion;
  final SolicitudViaje solicitud;

  String get _fecha {
    final DateTime ahora = DateTime.now();
    String dos(int valor) => valor.toString().padLeft(2, '0');
    return '${dos(ahora.day)}/${dos(ahora.month)}/${ahora.year} · '
        '${dos(ahora.hour)}:${dos(ahora.minute)}';
  }

  void _aviso(BuildContext context, String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texto, style: const TextStyle(fontSize: 11)),
          backgroundColor: AppTheme.dark,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _volverInicio(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.pasajero,
      (_) => false,
      arguments: sesion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: BarraFlujoCtm(
        eyebrow: 'RECIBO CTM',
        titulo: 'Viaje finalizado',
        detalle: solicitud.codigoRecibo,
        onAtras: () => Navigator.of(context).maybePop(),
      ),
      navegacion: BarraNavegacionCtm(
        rol: RolCtm.pasajero,
        activo: 'viajes',
        onInicio: () => _volverInicio(context),
        onViajes: () {},
        onTercero: () => _aviso(
          context,
          'La central de despacho CTM atiende 05:00 a 21:00.',
        ),
        onPerfil: () => volverASeleccionRol(context, sesion),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _encabezadoRecibo(),
          const SizedBox(height: 12),
          _ruta(),
          const SizedBox(height: 12),
          _desglose(),
          const SizedBox(height: 12),
          const AvisoCtm(
            tipo: TipoAviso.info,
            titulo: 'Comprobante del prototipo',
            texto:
                'Este recibo se genera localmente con fines de presentación. '
                'La facturación de la cooperativa se emite desde SITRAM.',
            icono: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 14),
          BotonCtm(
            texto: 'Volver al inicio',
            expandido: true,
            icono: const Icon(
              Icons.home_outlined,
              size: 15,
              color: AppTheme.blanco,
            ),
            onPressed: () => _volverInicio(context),
          ),
          const SizedBox(height: 8),
          BotonCtm(
            texto: 'Calificar el servicio',
            expandido: true,
            variante: VarianteBoton.contorno,
            icono: const Icon(
              Icons.star_outline_rounded,
              size: 15,
              color: AppTheme.verde800,
            ),
            onPressed: () => _aviso(
              context,
              'La calificación del socio conductor llegará en la próxima versión.',
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _encabezadoRecibo() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.verdeMenta,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 22,
                color: AppTheme.verde800,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '¡Gracias por viajar con CTM!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.titulo,
                    ),
                  ),
                  Text(
                    'Tu viaje se cerró correctamente.',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const PildoraCtm(
              texto: 'PAGADO',
              icono: Icons.check_circle_outline_rounded,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppTheme.divisor),
        const SizedBox(height: 8),
        FilaDato(etiqueta: 'Comprobante', valor: solicitud.codigoRecibo),
        FilaDato(etiqueta: 'Fecha', valor: _fecha),
        FilaDato(etiqueta: 'Unidad', valor: solicitud.unidadTexto),
        FilaDato(
          etiqueta: 'Socio conductor',
          valor: solicitud.conductor ?? 'Conductor por asignar',
        ),
      ],
    ),
  );

  
  Widget _ruta() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Recorrido',
          detalle: 'COMPLETADO',
          icono: IconosCtm.ruta,
        ),
        const SizedBox(height: 8),
        LineaTiempo(
          hitos: <HitoLinea>[
            HitoLinea(
              etiqueta: 'ORIGEN',
              titulo: solicitud.origen,
              detalle: solicitud.momentoTexto,
              activo: true,
            ),
            HitoLinea(
              etiqueta: 'DESTINO',
              titulo: solicitud.destino,
              detalle: solicitud.modalidad.titulo,
              activo: true,
            ),
          ],
        ),
      ],
    ),
  );

  
  Widget _desglose() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Detalle de pago',
          icono: IconosCtm.gestion,
        ),
        const SizedBox(height: 8),
        FilaDato(
          etiqueta: 'Tarifa ${solicitud.modalidad.nota.toLowerCase()}',
          valor: solicitud.modalidad.precioTexto,
        ),
        FilaDato(etiqueta: 'Carga', valor: solicitud.carga.nombre),
        FilaDato(
          etiqueta: 'Suplemento',
          valor: solicitud.carga.adicionalTexto,
        ),
        FilaDato(
          etiqueta: 'Forma de pago',
          valor: solicitud.metodoPago.titulo,
        ),
        if (solicitud.notas.isNotEmpty)
          FilaDato(etiqueta: 'Notas', valor: solicitud.notas),
        const Divider(height: 14, color: AppTheme.divisor),
        FilaDato(
          etiqueta: 'Total pagado',
          valor: solicitud.totalTexto,
          destacado: true,
        ),
      ],
    ),
  );
}
