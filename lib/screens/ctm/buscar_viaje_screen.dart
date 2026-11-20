import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/catalogo/catalogo_ctm.dart';
import '../../models/sesion/sesion.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'seleccion_transporte_screen.dart';






class BuscarViajeScreen extends StatefulWidget {
  const BuscarViajeScreen({
    required this.sesion,
    this.destinoInicial,
    super.key,
  });

  final Sesion sesion;

  
  final String? destinoInicial;

  @override
  State<BuscarViajeScreen> createState() => _BuscarViajeScreenState();
}

class _BuscarViajeScreenState extends State<BuscarViajeScreen> {
  late final TextEditingController _destino = TextEditingController(
    text: widget.destinoInicial ?? '',
  );

  
  int _modo = 0;

  @override
  void dispose() {
    _destino.dispose();
    super.dispose();
  }

  String get _hint => switch (_modo) {
    0 => 'Ej. Finca El Naranjal, Mercado Central…',
    1 => 'Ej. P-014, P-032',
    _ => 'Ej. Ruta 12, Ruta 08',
  };

  String get _texto => _destino.text.trim();

  void _elegirDestino(DestinoFrecuente destino) {
    setState(() {
      _destino.text = destino.nombre;
      _modo = 0;
    });
  }

  void _continuar() {
    if (_texto.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SeleccionTransporteScreen(sesion: widget.sesion, destino: _texto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      encabezado: BarraFlujoCtm(
        eyebrow: 'FLUJO DE RESERVA',
        titulo: 'Paso 1 de 4: Origen y Destino',
        detalle: 'Busca tu parada',
        onAtras: () => Navigator.of(context).maybePop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const BannerPaso(
            numero: 1,
            titulo: 'Origen y Destino',
            paso: 'Paso 1 de 4',
            progreso: 0.25,
          ),
          const SizedBox(height: 12),
          _mapa(),
          const SizedBox(height: 12),
          TarjetaCtm(
            radio: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SegmentadoCtm(
                  opciones: const <String>[
                    'Por destino',
                    'Código de parada',
                    'Ruta frecuente',
                  ],
                  seleccion: _modo,
                  onCambio: (int indice) => setState(() => _modo = indice),
                ),
                const SizedBox(height: 12),
                _filaOrigen(),
                const SizedBox(height: 10),
                CampoTexto(
                  controller: _destino,
                  hint: _hint,
                  icono: Icons.place_outlined,
                  teclado: TextInputType.text,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _continuar(),
                ),
                const SizedBox(height: 10),
                BotonCtm(
                  texto: 'Continuar a selección de unidad',
                  expandido: true,
                  icono: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppTheme.blanco,
                  ),
                  onPressed: _texto.isEmpty ? null : _continuar,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TituloSeccion(
            titulo: 'Destinos frecuentes',
            descripcion: 'Toca un destino para continuar la reserva.',
            icono: IconosCtm.ruta,
          ),
          const SizedBox(height: 8),
          for (final DestinoFrecuente destino in DestinoFrecuente.frecuentes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: BotonOpcion(
                activo: _texto == destino.nombre,
                onTap: () => _elegirDestino(destino),
                child: Row(
                  children: <Widget>[
                    const CajaIcono(Icons.place_outlined, lado: 32),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            destino.nombre,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.titulo,
                            ),
                          ),
                          Text(
                            destino.detalle,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PildoraCtm(texto: destino.ruta),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  
  Widget _mapa() => Container(
    height: 148,
    decoration: BoxDecoration(
      color: AppTheme.verdeMenta,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: <Widget>[
        Center(child: IconoCtm(IconosCtm.mapaBusqueda, alto: 148)),
        Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.blanco,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.my_location_rounded,
                  size: 13,
                  color: AppTheme.verde800,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    origenBaseCtm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.titulo,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _texto.isEmpty ? 'Destino pendiente' : _texto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.verde700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  
  Widget _filaOrigen() => Row(
    children: <Widget>[
      const CajaIcono(Icons.trip_origin_rounded, lado: 30),
      const SizedBox(width: 8),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ORIGEN',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              origenBaseCtm,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.titulo,
              ),
            ),
          ],
        ),
      ),
      TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'El prototipo parte siempre de la terminal de la cooperativa.',
                  style: TextStyle(fontSize: 11),
                ),
                backgroundColor: AppTheme.dark,
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
        child: const Text(
          'Cambiar',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.verde700,
          ),
        ),
      ),
    ],
  );
}
