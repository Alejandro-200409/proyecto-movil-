import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/catalogo/catalogo_ctm.dart';
import '../../models/sesion/sesion.dart';
import '../../models/solicitud/solicitud_viaje.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'confirmar_viaje_screen.dart';


class SeleccionTransporteScreen extends StatefulWidget {
  const SeleccionTransporteScreen({
    required this.sesion,
    required this.destino,
    this.modalidadInicial,
    super.key,
  });

  final Sesion sesion;
  final String destino;

  
  final ModalidadTransporte? modalidadInicial;

  @override
  State<SeleccionTransporteScreen> createState() =>
      _SeleccionTransporteScreenState();
}

class _SeleccionTransporteScreenState extends State<SeleccionTransporteScreen> {
  late ModalidadTransporte _modalidad =
      widget.modalidadInicial ?? ModalidadTransporte.opciones.first;
  OpcionCarga _carga = OpcionCarga.opciones.first;

  IconData _iconoDe(IconoTransporte icono) => switch (icono) {
    IconoTransporte.camioneta => Icons.local_shipping_outlined,
    IconoTransporte.buseta => Icons.directions_bus_outlined,
    IconoTransporte.flete => Icons.agriculture_outlined,
    IconoTransporte.expreso => Icons.bolt_rounded,
  };

  double get _total => _modalidad.precio + _carga.adicional;

  String get _totalTexto => '\$${_total.toStringAsFixed(2)}';

  void _continuar() {
    final borrador = SolicitudViaje(
      origen: origenBaseCtm,
      destino: widget.destino,
      modalidad: _modalidad,
      carga: _carga,
      metodoPago: MetodoPago.efectivo,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ConfirmarViajeScreen(sesion: widget.sesion, solicitud: borrador),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: BarraFlujoCtm(
        eyebrow: 'FLUJO DE RESERVA',
        titulo: 'Paso 2 de 4: Elegir Transporte',
        detalle: 'Unidad y carga',
        onAtras: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const BannerPaso(
            numero: 2,
            titulo: 'Selección de Unidad',
            paso: 'Paso 2 de 4',
            progreso: 0.5,
          ),
          const SizedBox(height: 12),
          _resumenRuta(),
          const SizedBox(height: 16),
          const TituloSeccion(
            titulo: 'Modalidades disponibles',
            descripcion: 'Tarifas referenciales del prototipo.',
            icono: IconosCtm.camioneta,
          ),
          const SizedBox(height: 8),
          ..._modalidades(),
          const SizedBox(height: 4),
          _seleccionCarga(),
        ],
      ),
    );
  }

  
  Widget _resumenRuta() => TarjetaCtm(
    radio: 14,
    child: LineaTiempo(
      hitos: <HitoLinea>[
        const HitoLinea(
          etiqueta: 'ORIGEN',
          titulo: origenBaseCtm,
          detalle: 'Terminal CTM · Bahía 3',
          activo: true,
        ),
        HitoLinea(
          etiqueta: 'DESTINO',
          titulo: widget.destino,
          detalle: 'Parada solicitada por el pasajero',
        ),
      ],
    ),
  );

  
  List<Widget> _modalidades() => <Widget>[
    for (final ModalidadTransporte modalidad
        in ModalidadTransporte.opciones) ...<Widget>[
      BotonOpcion(
        activo: modalidad.id == _modalidad.id,
        onTap: () => setState(() => _modalidad = modalidad),
        child: Row(
          children: <Widget>[
            CajaIcono(_iconoDe(modalidad.icono), lado: 36),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    modalidad.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.titulo,
                    ),
                  ),
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
                  Text(
                    modalidad.detalle,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.verde700,
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
    ],
  ];

  
  Widget _seleccionCarga() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const TituloSeccion(
        titulo: 'Tipo de carga',
        descripcion: 'El suplemento se suma a la tarifa de la modalidad.',
        icono: IconosCtm.flete,
      ),
      const SizedBox(height: 8),
      for (final OpcionCarga opcion in OpcionCarga.opciones) ...<Widget>[
        BotonOpcion(
          activo: opcion.id == _carga.id,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          onTap: () => setState(() => _carga = opcion),
          child: Row(
            children: <Widget>[
              Icon(
                opcion.id == _carga.id
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 17,
                color: opcion.id == _carga.id
                    ? AppTheme.verde800
                    : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      opcion.nombre,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.titulo,
                      ),
                    ),
                    Text(
                      opcion.detalle,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                opcion.adicionalTexto,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.verde700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
      TarjetaCtm(
        radio: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FilaDato(etiqueta: 'Modalidad', valor: _modalidad.titulo),
            FilaDato(etiqueta: 'Carga', valor: _carga.nombre),
            FilaDato(etiqueta: 'Suplemento', valor: _carga.adicionalTexto),
            const Divider(height: 14, color: AppTheme.divisor),
            FilaDato(
              etiqueta: 'Total estimado',
              valor: _totalTexto,
              destacado: true,
            ),
            const SizedBox(height: 10),
            BotonCtm(
              texto: 'Continuar a confirmación',
              expandido: true,
              icono: const Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: AppTheme.blanco,
              ),
              onPressed: _continuar,
            ),
            const SizedBox(height: 6),
            const Text(
              'Tarifas referenciales: el valor final lo fija el tarifario de '
              'la cooperativa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 8.5, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}
