import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/catalogo/catalogo_ctm.dart';
import '../../models/sesion/sesion.dart';
import '../../models/solicitud/solicitud_viaje.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'buscar_viaje_screen.dart';
import 'recibo_screen.dart';
import 'seleccion_transporte_screen.dart';
import 'sesion_ctm.dart';
import 'viaje_en_curso_screen.dart';







class InicioPasajeroScreen extends StatelessWidget {
  const InicioPasajeroScreen({required this.sesion, super.key});

  final Sesion sesion;

  void _abrirBusqueda(BuildContext context, {String? destino}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            BuscarViajeScreen(sesion: sesion, destinoInicial: destino),
      ),
    );
  }

  void _abrirViaje(BuildContext context, [SolicitudViaje? solicitud]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ViajeEnCursoScreen(
          sesion: sesion,
          solicitud: solicitud ?? solicitudDemoCtm,
        ),
      ),
    );
  }

  void _abrirTransporte(BuildContext context, ModalidadTransporte modalidad) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SeleccionTransporteScreen(
          sesion: sesion,
          destino: solicitudDemoCtm.destino,
          modalidadInicial: modalidad,
        ),
      ),
    );
  }

  void _abrirRecibo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ReciboScreen(sesion: sesion, solicitud: solicitudDemoCtm),
      ),
    );
  }

  void _mostrarHoja(BuildContext context, Widget contenido) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.blanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: contenido,
        ),
      ),
    );
  }

  void _mostrarSoporte(BuildContext context) => _mostrarHoja(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Soporte CTM',
          descripcion: 'Atención de la cooperativa para viajes y encomiendas.',
          icono: IconosCtm.info,
        ),
        const SizedBox(height: 12),
        const FilaDato(etiqueta: 'Central de despacho', valor: '02 2555 0199'),
        const FilaDato(etiqueta: 'WhatsApp', valor: '+593 99 555 0199'),
        const FilaDato(etiqueta: 'Horario', valor: '05:00 a 21:00'),
        const SizedBox(height: 10),
        const AvisoCtm(
          texto:
              'Las solicitudes del panel de pasajero son de presentación; '
              'el despacho lo registra la cooperativa desde administración.',
        ),
        const SizedBox(height: 12),
        BotonCtm(
          texto: 'Entendido',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );

  void _mostrarTarifario(BuildContext context) => _mostrarHoja(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Tarifario referencial',
          descripcion: 'Valores del prototipo, sujetos al tarifario oficial.',
          icono: IconosCtm.ruta,
        ),
        const SizedBox(height: 10),
        for (final ModalidadTransporte modalidad
            in ModalidadTransporte.opciones)
          FilaDato(
            etiqueta: '${modalidad.titulo} · ${modalidad.nota}',
            valor: modalidad.precioTexto,
          ),
        const SizedBox(height: 12),
        BotonCtm(
          texto: 'Cerrar',
          variante: VarianteBoton.contorno,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );

  void _mostrarParadas(BuildContext context) => _mostrarHoja(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Paradas y rutas',
          descripcion: 'Puntos de abordaje frecuentes del prototipo.',
          icono: IconosCtm.ruta,
        ),
        const SizedBox(height: 10),
        for (final DestinoFrecuente destino in DestinoFrecuente.frecuentes)
          FilaDato(
            etiqueta: '${destino.ruta} · ${destino.detalle}',
            valor: destino.nombre,
          ),
        const SizedBox(height: 12),
        BotonCtm(
          texto: 'Cerrar',
          variante: VarianteBoton.contorno,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );


  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: EncabezadoCtm(
        rol: RolCtm.pasajero,
        subtitulo: 'PASAJERO',
        onPerfil: () => volverASeleccionRol(context, sesion),
      ),
      navegacion: BarraNavegacionCtm(
        rol: RolCtm.pasajero,
        activo: 'inicio',
        onInicio: () {},
        onViajes: () => _abrirViaje(context),
        onTercero: () => _mostrarSoporte(context),
        onPerfil: () => volverASeleccionRol(context, sesion),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _bienvenida(),
          const SizedBox(height: 12),
          _viajeActivo(context),
          const SizedBox(height: 16),
          const TituloSeccion(
            titulo: 'Solicitar nuevo viaje o encomienda',
            descripcion: 'Indica tu destino y elige la unidad disponible.',
            icono: IconosCtm.ruta,
          ),
          const SizedBox(height: 8),
          _buscadorDestino(context),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final DestinoFrecuente destino
                  in DestinoFrecuente.frecuentes)
                _chipDestino(context, destino),
            ],
          ),
          const SizedBox(height: 16),
          const TituloSeccion(
            titulo: 'Modalidad de transporte',
            descripcion: 'Camioneta, buseta, flete o expreso puerta a puerta.',
            icono: IconosCtm.camioneta,
          ),
          const SizedBox(height: 8),
          for (final ModalidadTransporte modalidad
              in ModalidadTransporte.opciones) ...<Widget>[
            _tarjetaModalidad(context, modalidad),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          const TituloSeccion(
            titulo: 'Herramientas rápidas',
            descripcion: 'Historial, tarifas, paradas y soporte.',
            icono: IconosCtm.gestion,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _herramienta(
                  icono: Icons.history_rounded,
                  titulo: 'Historial',
                  detalle: 'Último recibo',
                  onTap: () => _abrirRecibo(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _herramienta(
                  icono: Icons.receipt_long_outlined,
                  titulo: 'Tarifario',
                  detalle: 'Precios base',
                  onTap: () => _mostrarTarifario(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _herramienta(
                  icono: Icons.signpost_outlined,
                  titulo: 'Paradas',
                  detalle: 'Rutas y puntos',
                  onTap: () => _mostrarParadas(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _herramienta(
                  icono: Icons.support_agent_rounded,
                  titulo: 'Soporte',
                  detalle: 'Central CTM',
                  onTap: () => _mostrarSoporte(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const AvisoCtm(
            tipo: TipoAviso.info,
            titulo: 'Panel de presentación',
            texto:
                'El viaje activo y las tarifas son del prototipo. Los paneles '
                'de conductor y administración sí consultan la API de SITRAM.',
          ),
        ],
      ),
    );
  }

  
  Widget _bienvenida() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[AppTheme.verde800, AppTheme.verdeProfundo],
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'RED CTM ACTIVA',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.verde100.withValues(alpha: 0.9),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const PildoraCtm(
              texto: '● En línea',
              fondo: Color(0x3328B76B),
              colorTexto: AppTheme.verde100,
              colorBorde: Color(0x5528B76B),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Hola, ${sesion.nombreVisible}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppTheme.blanco,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Terminal Central CTM · Bahía 3',
          style: TextStyle(
            fontSize: 10.5,
            color: AppTheme.blanco.withValues(alpha: 0.75),
          ),
        ),
      ],
    ),
  );

  
  Widget _viajeActivo(BuildContext context) => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Viaje activo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                ),
              ),
            ),
            const PildoraCtm(
              texto: 'EN CAMINO',
              icono: Icons.local_shipping_outlined,
            ),
          ],
        ),
        const SizedBox(height: 10),
        LineaTiempo(
          hitos: <HitoLinea>[
            HitoLinea(
              etiqueta: 'ORIGEN',
              titulo: solicitudDemoCtm.origen,
              detalle: 'Salida confirmada',
              activo: true,
            ),
            HitoLinea(
              etiqueta: 'DESTINO',
              titulo: solicitudDemoCtm.destino,
              detalle: solicitudDemoCtm.modalidad.titulo,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppTheme.divisor),
        const SizedBox(height: 8),
        FilaDato(
          etiqueta: 'Unidad',
          valor: solicitudDemoCtm.unidadTexto,
          icono: IconosCtm.camioneta,
        ),
        FilaDato(
          etiqueta: 'Conductor',
          valor: solicitudDemoCtm.conductor ?? 'Por asignar',
        ),
        const SizedBox(height: 10),
        BotonCtm(
          texto: 'Ver ruta en vivo',
          expandido: true,
          icono: const Icon(
            Icons.navigation_rounded,
            size: 15,
            color: AppTheme.blanco,
          ),
          onPressed: () => _abrirViaje(context),
        ),
      ],
    ),
  );

  
  Widget _buscadorDestino(BuildContext context) => TarjetaCtm(
    radio: 12,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    onTap: () => _abrirBusqueda(context),
    child: const Row(
      children: <Widget>[
        CajaIcono(Icons.search_rounded, lado: 34),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '¿A dónde vas hoy?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Destino, código de parada o ruta frecuente',
                style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: AppTheme.verde700,
        ),
      ],
    ),
  );


  
  Widget _chipDestino(BuildContext context, DestinoFrecuente destino) =>
      Material(
        color: AppTheme.verdeMenta,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _abrirBusqueda(context, destino: destino.nombre),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.place_outlined,
                  size: 12,
                  color: AppTheme.verde800,
                ),
                const SizedBox(width: 4),
                Text(
                  destino.nombre,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.verde800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  IconData _iconoModalidad(IconoTransporte icono) => switch (icono) {
    IconoTransporte.camioneta => Icons.local_shipping_outlined,
    IconoTransporte.buseta => Icons.directions_bus_outlined,
    IconoTransporte.flete => Icons.agriculture_outlined,
    IconoTransporte.expreso => Icons.bolt_rounded,
  };

  
  Widget _tarjetaModalidad(
    BuildContext context,
    ModalidadTransporte modalidad,
  ) => TarjetaCtm(
    radio: 12,
    padding: const EdgeInsets.all(12),
    onTap: () => _abrirTransporte(context, modalidad),
    child: Row(
      children: <Widget>[
        CajaIcono(_iconoModalidad(modalidad.icono), lado: 38),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                modalidad.titulo,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                modalidad.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppTheme.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              modalidad.precioTexto,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.verde800,
              ),
            ),
            Text(
              modalidad.nota,
              style: const TextStyle(
                fontSize: 8.5,
                color: AppTheme.textMuted,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  
  Widget _herramienta({
    required IconData icono,
    required String titulo,
    required String detalle,
    required VoidCallback onTap,
  }) => TarjetaCtm(
    radio: 12,
    padding: const EdgeInsets.all(11),
    onTap: onTap,
    child: Row(
      children: <Widget>[
        CajaIcono(icono, lado: 32),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                ),
              ),
              Text(
                detalle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
