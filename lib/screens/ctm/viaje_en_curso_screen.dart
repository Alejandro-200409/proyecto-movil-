import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/sesion/sesion.dart';
import '../../models/solicitud/solicitud_viaje.dart';
import '../../routes/app_routes.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'recibo_screen.dart';
import 'sesion_ctm.dart';


class ViajeEnCursoScreen extends StatefulWidget {
  const ViajeEnCursoScreen({
    required this.sesion,
    required this.solicitud,
    super.key,
  });

  final Sesion sesion;
  final SolicitudViaje solicitud;

  @override
  State<ViajeEnCursoScreen> createState() => _ViajeEnCursoScreenState();
}

class _ViajeEnCursoScreenState extends State<ViajeEnCursoScreen> {
  
  bool _llego = false;

  double get _progreso => _llego ? 1 : 0.4;

  String get _estado => _llego ? 'Unidad en el punto' : 'En camino';

  void _finalizar() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReciboScreen(
          sesion: widget.sesion,
          solicitud: widget.solicitud,
        ),
      ),
    );
  }

  void _aviso(String texto) {
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

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: BarraFlujoCtm(
        eyebrow: 'FLUJO DE RESERVA',
        titulo: 'Paso 4 de 4: Viaje en Curso',
        detalle: _estado.toUpperCase(),
        onAtras: () => Navigator.of(context).maybePop(),
      ),
      navegacion: BarraNavegacionCtm(
        rol: RolCtm.pasajero,
        activo: 'viajes',
        onInicio: () => Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.pasajero,
          (_) => false,
          arguments: widget.sesion,
        ),
        onViajes: () {},
        onTercero: () => _aviso('La central de despacho CTM atiende 05:00 a 21:00.'),
        onPerfil: () => volverASeleccionRol(context, widget.sesion),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BannerPaso(
            numero: 4,
            titulo: _llego
                ? 'La unidad está en tu parada'
                : 'Seguimiento del viaje',
            paso: 'Paso 4 de 4',
            progreso: _progreso,
          ),
          const SizedBox(height: 12),
          _seguimiento(),
          const SizedBox(height: 12),
          _conductor(),
          const SizedBox(height: 12),
          _itinerario(),
          const SizedBox(height: 12),
          _detalle(),
          const SizedBox(height: 12),
          const AvisoCtm(
            tipo: TipoAviso.advertencia,
            titulo: 'Seguimiento de presentación',
            texto:
                'El mapa y el estado del viaje son del prototipo. El despacho '
                'real se controla desde el panel de administración.',
            icono: Icons.map_outlined,
          ),
        ],
      ),
    );
  }

  
  Widget _seguimiento() => Container(
    decoration: BoxDecoration(
      color: AppTheme.verdeMenta,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 150,
          child: Stack(
            children: <Widget>[
              Center(child: IconoCtm(IconosCtm.mapaViaje, alto: 150)),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.blanco,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 13,
                        color: AppTheme.verde800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.solicitud.unidadTexto,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.titulo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: PildoraCtm(
                  texto: _estado.toUpperCase(),
                  icono: Icons.bolt_rounded,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.verde800,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    _llego ? '0 min' : '4 min',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.blanco,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: AppTheme.blanco,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Tiempo estimado de llegada',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                  Text(
                    _llego ? 'Unidad en parada' : '4 minutos',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.verde800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              BarraProgreso(valor: _progreso),
              const SizedBox(height: 10),
              BotonCtm(
                texto: _llego
                    ? 'Finalizar viaje y ver recibo'
                    : 'Simular llegada de la unidad',
                expandido: true,
                variante: _llego
                    ? VarianteBoton.primario
                    : VarianteBoton.contorno,
                icono: Icon(
                  _llego
                      ? Icons.receipt_long_outlined
                      : Icons.my_location_rounded,
                  size: 15,
                  color: _llego ? AppTheme.blanco : AppTheme.verde800,
                ),
                onPressed: _llego
                    ? _finalizar
                    : () => setState(() => _llego = true),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  
  Widget _conductor() {
    final solicitud = widget.solicitud;
    final nombre = solicitud.conductor ?? 'Conductor por asignar';
    final iniciales = nombre
        .split(RegExp(r'\s+'))
        .where((String parte) => parte.isNotEmpty)
        .take(2)
        .map((String parte) => parte.substring(0, 1).toUpperCase())
        .join();
    return TarjetaCtm(
      radio: 14,
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.verdeMenta,
              shape: BoxShape.circle,
            ),
            child: Text(
              iniciales.isEmpty ? 'CTM' : iniciales,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.verde800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titulo,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Socio conductor · ${solicitud.unidadTexto}',
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                const PildoraCtm(
                  texto: 'VERIFICADO',
                  icono: Icons.verified_user_outlined,
                ),
              ],
            ),
          ),
          BotonIconoCtm(
            lado: 34,
            iconoMaterial: Icons.call_outlined,
            onTap: () => _aviso('Llamada al socio conductor (prototipo).'),
          ),
          const SizedBox(width: 6),
          BotonIconoCtm(
            lado: 34,
            iconoMaterial: Icons.chat_bubble_outline_rounded,
            onTap: () => _aviso('Mensaje al socio conductor (prototipo).'),
          ),
        ],
      ),
    );
  }

  
  Widget _itinerario() {
    final solicitud = widget.solicitud;
    return TarjetaCtm(
      radio: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const TituloSeccion(
            titulo: 'Itinerario',
            icono: IconosCtm.ruta,
          ),
          const SizedBox(height: 8),
          LineaTiempo(
            hitos: <HitoLinea>[
              HitoLinea(
                etiqueta: 'ORIGEN',
                titulo: solicitud.origen,
                detalle: solicitud.momentoTexto,
                activo: _llego,
              ),
              HitoLinea(
                etiqueta: 'DESTINO',
                titulo: solicitud.destino,
                detalle: solicitud.modalidad.titulo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  
  Widget _detalle() {
    final solicitud = widget.solicitud;
    return TarjetaCtm(
      radio: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const TituloSeccion(
            titulo: 'Detalle del servicio',
            icono: IconosCtm.gestion,
          ),
          const SizedBox(height: 8),
          FilaDato(etiqueta: 'Modalidad', valor: solicitud.modalidad.titulo),
          FilaDato(etiqueta: 'Carga', valor: solicitud.carga.nombre),
          FilaDato(etiqueta: 'Pago', valor: solicitud.metodoPago.titulo),
          if (solicitud.notas.isNotEmpty)
            FilaDato(etiqueta: 'Notas', valor: solicitud.notas),
          const Divider(height: 14, color: AppTheme.divisor),
          FilaDato(
            etiqueta: 'Total',
            valor: solicitud.totalTexto,
            destacado: true,
          ),
        ],
      ),
    );
  }
}
