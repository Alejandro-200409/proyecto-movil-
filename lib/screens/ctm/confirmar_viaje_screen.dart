import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/sesion/sesion.dart';
import '../../models/solicitud/solicitud_viaje.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'viaje_en_curso_screen.dart';


class ConfirmarViajeScreen extends StatefulWidget {
  const ConfirmarViajeScreen({
    required this.sesion,
    required this.solicitud,
    super.key,
  });

  final Sesion sesion;
  final SolicitudViaje solicitud;

  @override
  State<ConfirmarViajeScreen> createState() => _ConfirmarViajeScreenState();
}

class _ConfirmarViajeScreenState extends State<ConfirmarViajeScreen> {
  final TextEditingController _notas = TextEditingController();

  MetodoPago _pago = MetodoPago.efectivo;
  bool _inmediato = true;
  TimeOfDay _hora = TimeOfDay.now();

  String get _horaTexto =>
      '${_hora.hour.toString().padLeft(2, '0')}:'
      '${_hora.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _notas.dispose();
    super.dispose();
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: _hora,
      helpText: 'Hora de salida',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (elegida == null) return;
    setState(() => _hora = elegida);
  }

  void _confirmar() {
    final solicitud = widget.solicitud.conPago(
      metodoPago: _pago,
      inmediato: _inmediato,
      horaProgramada: _inmediato ? null : _horaTexto,
      notas: _notas.text.trim(),
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ViajeEnCursoScreen(sesion: widget.sesion, solicitud: solicitud),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final solicitud = widget.solicitud;
    return PaginaCtm(
      encabezado: BarraFlujoCtm(
        eyebrow: 'FLUJO DE RESERVA',
        titulo: 'Paso 3 de 4: Confirmar Viaje',
        detalle: 'Pago y horario',
        onAtras: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const BannerPaso(
            numero: 3,
            titulo: 'Confirmación de la Solicitud',
            paso: 'Paso 3 de 4',
            progreso: 0.75,
          ),
          const SizedBox(height: 12),
          _comprobante(solicitud),
          const SizedBox(height: 14),
          _horario(),
          const SizedBox(height: 14),
          _formaPago(),
          const SizedBox(height: 14),
          _campoNotas(),
          const SizedBox(height: 12),
          const AvisoCtm(
            tipo: TipoAviso.info,
            titulo: 'Asignación automática',
            texto:
                'La cooperativa asigna la unidad por turno. Si ninguna unidad '
                'está disponible, la central de despacho te contactará.',
            icono: Icons.alt_route_rounded,
          ),
          const SizedBox(height: 12),
          BotonCtm(
            texto: 'Solicitar ${solicitud.modalidad.titulo} · '
                '${solicitud.totalTexto}',
            expandido: true,
            icono: const Icon(
              Icons.local_shipping_outlined,
              size: 15,
              color: AppTheme.blanco,
            ),
            onPressed: _confirmar,
          ),
          const SizedBox(height: 6),
          const Text(
            'Las solicitudes del prototipo no se envían a la API: el despacho '
            'real lo registra la cooperativa desde administración.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8.5, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  
  Widget _comprobante(SolicitudViaje solicitud) => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Comprobante previo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                ),
              ),
            ),
            PildoraCtm(texto: solicitud.modalidad.nota),
          ],
        ),
        const SizedBox(height: 10),
        LineaTiempo(
          hitos: <HitoLinea>[
            HitoLinea(
              etiqueta: 'ORIGEN',
              titulo: solicitud.origen,
              detalle: 'Terminal CTM · Bahía 3',
              activo: true,
            ),
            HitoLinea(
              etiqueta: 'DESTINO',
              titulo: solicitud.destino,
              detalle: solicitud.modalidad.titulo,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppTheme.divisor),
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
        const Divider(height: 14, color: AppTheme.divisor),
        FilaDato(
          etiqueta: 'Total a pagar',
          valor: solicitud.totalTexto,
          destacado: true,
        ),
      ],
    ),
  );

  
  Widget _horario() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Horario de salida',
          icono: IconosCtm.turno,
        ),
        const SizedBox(height: 8),
        SegmentadoCtm(
          opciones: const <String>['Inmediato (ahora)', 'Programar hora'],
          seleccion: _inmediato ? 0 : 1,
          onCambio: (int indice) => setState(() => _inmediato = indice == 0),
        ),
        if (!_inmediato) ...<Widget>[
          const SizedBox(height: 10),
          BotonOpcion(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            onTap: _elegirHora,
            child: Row(
              children: <Widget>[
                const CajaIcono(Icons.schedule_rounded, lado: 30),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Hora de salida',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.titulo,
                    ),
                  ),
                ),
                Text(
                  _horaTexto,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.verde800,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 17,
                  color: AppTheme.verde700,
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  
  Widget _formaPago() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Forma de pago',
          descripcion: 'El cobro se realiza al abordar la unidad.',
          icono: IconosCtm.info,
        ),
        const SizedBox(height: 8),
        for (final MetodoPago metodo in MetodoPago.values) ...<Widget>[
          BotonOpcion(
            activo: metodo == _pago,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            onTap: () => setState(() => _pago = metodo),
            child: Row(
              children: <Widget>[
                Icon(
                  metodo == _pago
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 17,
                  color: metodo == _pago
                      ? AppTheme.verde800
                      : AppTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        metodo.titulo,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.titulo,
                        ),
                      ),
                      Text(
                        metodo.detalle,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );

  
  Widget _campoNotas() => TarjetaCtm(
    radio: 14,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TituloSeccion(
          titulo: 'Notas para el conductor',
          descripcion: 'Referencias de la carga o de la parada.',
          icono: IconosCtm.menu,
        ),
        const SizedBox(height: 8),
        CampoTexto(
          controller: _notas,
          hint: 'Ej. Llevo dos sacos de café, espero en el cruce…',
          icono: Icons.edit_note_rounded,
          maxLineas: 3,
          teclado: TextInputType.multiline,
        ),
      ],
    ),
  );
}
