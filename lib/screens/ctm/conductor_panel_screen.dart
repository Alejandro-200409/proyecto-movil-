import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../config/app_theme.dart';
import '../../models/common/page_query.dart';
import '../../models/despacho/despacho.dart';
import '../../models/planilla/planilla.dart';
import '../../models/sesion/sesion.dart';
import '../../models/vehiculo/vehiculo.dart';
import '../../services/remote/api_service.dart';
import '../../services/remote/mi_cuenta_api.dart';
import '../../utils/api_error_message.dart';
import '../../utils/fechas.dart';
import '../../utils/montos.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'sesion_ctm.dart';


enum _Seccion { inicio, viajes, turno }







class ConductorPanelScreen extends StatefulWidget {
  const ConductorPanelScreen({required this.sesion, this.api, super.key});

  final Sesion sesion;

  
  final MiCuentaApi? api;

  @override
  State<ConductorPanelScreen> createState() => _ConductorPanelScreenState();
}

class _ConductorPanelScreenState extends State<ConductorPanelScreen> {
  static const int _pageSize = 20;

  late final MiCuentaApi _api =
      widget.api ??
      MiCuentaApi(
        api: ApiService(baseUrl: AppConfig.apiBaseUrl),
        token: widget.sesion.token,
      );

  final List<Vehiculo> _vehiculos = <Vehiculo>[];
  final List<Planilla> _viajes = <Planilla>[];
  final List<Despacho> _despachos = <Despacho>[];

  _Seccion _seccion = _Seccion.inicio;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }
    const query = PageQuery(page: 1, pageSize: _pageSize);
    try {
      final vehiculos = await _api.vehiculos();
      final viajes = await _api.viajes(query: query);
      final despachos = await _api.despachos(query: query);
      if (!mounted) return;
      setState(() {
        _vehiculos
          ..clear()
          ..addAll(vehiculos);
        _viajes
          ..clear()
          ..addAll(viajes);
        _despachos
          ..clear()
          ..addAll(despachos);
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = mensajeDeApi(error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo conectar con la API.');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _cambiarSeccion(_Seccion seccion) {
    if (seccion == _seccion) return;
    setState(() => _seccion = seccion);
  }

  double get _recaudado => _viajes.fold<double>(
    0,
    (double total, Planilla planilla) => total + planilla.valorPagado,
  );

  int get _pendientes =>
      _viajes.where((Planilla planilla) => !planilla.estaPagada).length;

  String get _activo => switch (_seccion) {
    _Seccion.inicio => 'inicio',
    _Seccion.viajes => 'viajes',
    _Seccion.turno => 'tercero',
  };

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: EncabezadoCtm(
        rol: RolCtm.conductor,
        subtitulo: 'SOCIO CONDUCTOR',
        onPerfil: () => volverASeleccionRol(context, widget.sesion),
      ),
      navegacion: BarraNavegacionCtm(
        rol: RolCtm.conductor,
        activo: _activo,
        onInicio: () => _cambiarSeccion(_Seccion.inicio),
        onViajes: () => _cambiarSeccion(_Seccion.viajes),
        onTercero: () => _cambiarSeccion(_Seccion.turno),
        onPerfil: () => volverASeleccionRol(context, widget.sesion),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _bienvenida(),
          const SizedBox(height: 12),
          _resumen(),
          const SizedBox(height: 14),
          if (_cargando)
            const CargandoCtm(mensaje: 'Consultando tu cuenta…')
          else if (_error != null)
            MensajeErrorCtm(mensaje: _error!, onReintentar: _cargar)
          else
            ..._contenido(),
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
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.blanco.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.blanco.withValues(alpha: 0.28),
                ),
              ),
              child: Text(
                widget.sesion.inicialesVisible,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.blanco,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hola, ${widget.sesion.nombreVisible}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.blanco,
                    ),
                  ),
                  Text(
                    widget.sesion.empresa ?? 'Cooperativa de Transportes Mixtos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppTheme.blanco.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            PildoraCtm(
              texto: widget.sesion.etiquetaRol.toUpperCase(),
              fondo: AppTheme.blanco.withValues(alpha: 0.16),
              colorTexto: AppTheme.blanco,
              colorBorde: AppTheme.blanco.withValues(alpha: 0.3),
              icono: Icons.shield_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Tus unidades, viajes y despachos del día llegan desde SITRAM con tu '
          'token de asociado.',
          style: TextStyle(
            fontSize: 10,
            height: 1.35,
            color: AppTheme.blanco.withValues(alpha: 0.8),
          ),
        ),
      ],
    ),
  );

  
  Widget _resumen() {
    final String viajes = _cargando && _viajes.isEmpty ? '—' : '${_viajes.length}';
    final String recaudado = _cargando && _viajes.isEmpty
        ? '—'
        : formatearMonto(_recaudado);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: FichaMetrica(
                etiqueta: 'Unidades',
                valor: _cargando && _vehiculos.isEmpty
                    ? '—'
                    : '${_vehiculos.length}',
                detalle: 'afiliadas a tu perfil',
                icono: IconosCtm.camioneta,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FichaMetrica(
                etiqueta: 'Viajes',
                valor: viajes,
                detalle: 'registrados',
                icono: IconosCtm.viajes,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: FichaMetrica(
                etiqueta: 'Recaudado',
                valor: recaudado,
                detalle: 'en viajes',
                icono: IconosCtm.gestion,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FichaMetrica(
                etiqueta: 'Pendientes',
                valor: _cargando && _viajes.isEmpty ? '—' : '$_pendientes',
                detalle: 'por pagar',
                icono: IconosCtm.info,
                colorValor: AppTheme.warningTexto,
                fondoIcono: AppTheme.warningSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  List<Widget> _contenido() => switch (_seccion) {
    _Seccion.inicio => <Widget>[
      _seccionUnidades(),
      const SizedBox(height: 14),
      _seccionUltimosViajes(),
    ],
    _Seccion.viajes => <Widget>[_seccionViajes()],
    _Seccion.turno => <Widget>[_seccionDespachos()],
  };

  
  Widget _seccionUnidades() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const TituloSeccion(
        titulo: 'Mis unidades',
        descripcion: 'Vehículos habilitados en la cooperativa.',
        icono: IconosCtm.camioneta,
      ),
      const SizedBox(height: 8),
      if (_vehiculos.isEmpty)
        const EstadoVacioCtm(
          titulo: 'Sin unidades registradas',
          mensaje:
              'Cuando la cooperativa afilie un vehículo a tu identificación '
              'aparecerá aquí.',
          icono: IconosCtm.camioneta,
          iconoMaterial: Icons.local_shipping_outlined,
        )
      else
        for (final Vehiculo vehiculo in _vehiculos) ...<Widget>[
          TarjetaCtm(
            radio: 12,
            onTap: () => _detalleVehiculo(vehiculo),
            child: Row(
              children: <Widget>[
                const CajaIcono(Icons.local_shipping_outlined, lado: 34),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        vehiculo.placa,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.titulo,
                        ),
                      ),
                      Text(
                        '${vehiculo.marca} ${vehiculo.modelo} · '
                        '${vehiculo.tipo}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                PildoraCtm(
                  texto: vehiculo.soatVencido ? 'SOAT VENCIDO' : 'AL DÍA',
                  icono: vehiculo.soatVencido
                      ? Icons.warning_amber_rounded
                      : Icons.verified_outlined,
                  fondo: vehiculo.soatVencido
                      ? AppTheme.dangerSurface
                      : const Color(0x8CB2F1C4),
                  colorTexto: vehiculo.soatVencido
                      ? AppTheme.danger
                      : AppTheme.verde800,
                  colorBorde: vehiculo.soatVencido
                      ? AppTheme.danger.withValues(alpha: 0.3)
                      : const Color(0x401E6F43),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
    ],
  );

  
  Widget _seccionUltimosViajes() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      TituloSeccion(
        titulo: 'Últimos viajes',
        descripcion: 'Planillas de tipo VIAJE de tu cuenta.',
        detalle: '${_viajes.length}',
        icono: IconosCtm.viajes,
      ),
      const SizedBox(height: 8),
      if (_viajes.isEmpty)
        const EstadoVacioCtm(
          titulo: 'Todavía no hay viajes',
          mensaje:
              'Los viajes se registran en planillas desde la administración de '
              'la cooperativa.',
          icono: IconosCtm.viajes,
          iconoMaterial: Icons.route_outlined,
        )
      else
        for (final Planilla planilla in _viajes.take(3)) ...<Widget>[
          _tarjetaPlanilla(planilla),
          const SizedBox(height: 8),
        ],
    ],
  );

  
  Widget _seccionViajes() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      TituloSeccion(
        titulo: 'Mis viajes',
        descripcion: 'Planillas de tipo VIAJE registradas a tu nombre.',
        detalle: '${_viajes.length}',
        icono: IconosCtm.viajes,
      ),
      const SizedBox(height: 8),
      if (_viajes.isEmpty)
        const EstadoVacioCtm(
          titulo: 'Sin viajes registrados',
          mensaje:
              'La API de mi cuenta solo devuelve los viajes posteriores al '
              'inicio de las afiliaciones activas.',
          icono: IconosCtm.viajes,
          iconoMaterial: Icons.route_outlined,
        )
      else
        for (final Planilla planilla in _viajes) ...<Widget>[
          _tarjetaPlanilla(planilla),
          const SizedBox(height: 8),
        ],
    ],
  );

  
  Widget _seccionDespachos() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const TituloSeccion(
        titulo: 'Turno y despachos',
        descripcion: 'Salidas autorizadas por la central de despacho.',
        icono: IconosCtm.turno,
      ),
      const SizedBox(height: 8),
      if (_despachos.isEmpty)
        const EstadoVacioCtm(
          titulo: 'Sin despachos en el turno',
          mensaje:
              'Cuando la administración autorice una salida aparecerá en esta '
              'sección.',
          icono: IconosCtm.turno,
          iconoMaterial: Icons.alt_route_rounded,
        )
      else
        for (final Despacho despacho in _despachos) ...<Widget>[
          _tarjetaDespacho(despacho),
          const SizedBox(height: 8),
        ],
    ],
  );

  
  Widget _tarjetaPlanilla(Planilla planilla) {
    final String hora = planilla.hora == null
        ? '—'
        : (planilla.hora!.length >= 5
              ? planilla.hora!.substring(0, 5)
              : planilla.hora!);
    final bool pagada = planilla.estaPagada;
    return TarjetaCtm(
      radio: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Viaje #${planilla.numero ?? '—'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titulo,
                  ),
                ),
              ),
              PildoraCtm(
                texto: planilla.estadoPago.apiValue,
                icono: pagada
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_rounded,
                fondo: pagada
                    ? const Color(0x8CB2F1C4)
                    : AppTheme.warningSurface,
                colorTexto: pagada ? AppTheme.verde800 : AppTheme.warningTexto,
                colorBorde: pagada
                    ? const Color(0x401E6F43)
                    : AppTheme.warning.withValues(alpha: 0.35),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FilaDato(
            etiqueta: 'Fecha',
            valor: '${formatearFecha(planilla.fecha)} · $hora',
          ),
          FilaDato(etiqueta: 'Placa', valor: planilla.placaVehiculo ?? '—'),
          FilaDato(etiqueta: 'Tipo', valor: planilla.tipo ?? 'VIAJE'),
          FilaDato(
            etiqueta: 'Valor',
            valor: formatearMonto(planilla.valorPagado),
            destacado: true,
          ),
        ],
      ),
    );
  }

  
  Widget _tarjetaDespacho(Despacho despacho) {
    final String hora = despacho.hora == null
        ? '—'
        : (despacho.hora!.length >= 5
              ? despacho.hora!.substring(0, 5)
              : despacho.hora!);
    final bool cancelado = despacho.estaCancelado;
    return TarjetaCtm(
      radio: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  despacho.ruta.isEmpty ? 'Ruta sin nombre' : despacho.ruta,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titulo,
                  ),
                ),
              ),
              PildoraCtm(
                texto: despacho.estado.apiValue,
                fondo: cancelado
                    ? AppTheme.dangerSurface
                    : const Color(0x8CB2F1C4),
                colorTexto: cancelado ? AppTheme.danger : AppTheme.verde800,
                colorBorde: cancelado
                    ? AppTheme.danger.withValues(alpha: 0.3)
                    : const Color(0x401E6F43),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FilaDato(
            etiqueta: 'Salida',
            valor: '${formatearFecha(despacho.fecha)} · $hora',
          ),
          FilaDato(etiqueta: 'Unidad', valor: despacho.placaVehiculo),
          FilaDato(
            etiqueta: 'Pasajeros',
            valor: '${despacho.numeroPasajeros}',
            destacado: true,
          ),
        ],
      ),
    );
  }

  
  void _detalleVehiculo(Vehiculo vehiculo) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.blanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TituloSeccion(
                titulo: vehiculo.placa,
                descripcion: '${vehiculo.marca} ${vehiculo.modelo}',
                icono: IconosCtm.camioneta,
              ),
              const SizedBox(height: 10),
              FilaDato(etiqueta: 'Tipo', valor: vehiculo.tipo),
              FilaDato(
                etiqueta: 'Capacidad',
                valor: '${vehiculo.capacidadPasajeros} pasajeros',
              ),
              FilaDato(
                etiqueta: 'Tarjeta de propiedad',
                valor: vehiculo.tarjetaPropiedad,
              ),
              FilaDato(
                etiqueta: 'Tarifa',
                valor: formatearMonto(vehiculo.tarifa?.total),
              ),
              FilaDato(
                etiqueta: 'SOAT',
                valor: formatearFecha(vehiculo.vigenciaSoat),
              ),
              FilaDato(
                etiqueta: 'TRM',
                valor: formatearFecha(vehiculo.vigenciaTrm),
              ),
              FilaDato(
                etiqueta: 'Ingreso',
                valor: formatearFecha(vehiculo.fechaIngreso),
              ),
              const SizedBox(height: 12),
              BotonCtm(
                texto: 'Cerrar',
                variante: VarianteBoton.contorno,
                expandido: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
