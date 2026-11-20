





library;


const String origenBaseCtm = 'Terminal Central CTM - Bahía 3';


enum IconoTransporte { camioneta, buseta, flete, expreso }


class ModalidadTransporte {
  const ModalidadTransporte({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.detalle,
    required this.precio,
    required this.nota,
    required this.icono,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String detalle;

  
  final double precio;

  
  final String nota;
  final IconoTransporte icono;

  String get precioTexto => '\$${precio.toStringAsFixed(2)}';

  static const List<ModalidadTransporte> opciones = <ModalidadTransporte>[
    ModalidadTransporte(
      id: 'truck',
      titulo: 'Camioneta Doble Cabina',
      descripcion: 'Hasta 4 pasajeros + balde para carga hasta 200 kg',
      detalle: '4 min de espera • Balde libre',
      precio: 2.50,
      nota: 'Base',
      icono: IconoTransporte.camioneta,
    ),
    ModalidadTransporte(
      id: 'bus',
      titulo: 'Buseta Mixta Interparroquial',
      descripcion: 'Ruta fija regular con parrilla para sacos',
      detalle: 'Turno cada 15 min • 18 asientos',
      precio: 1.00,
      nota: 'Por pax',
      icono: IconoTransporte.buseta,
    ),
    ModalidadTransporte(
      id: 'freight',
      titulo: 'Flete / Carga Agrícola',
      descripcion: 'Camioneta con estacas o furgón para cosechas y abono',
      detalle: 'Capacidad total hasta 1 Ton',
      precio: 5.00,
      nota: 'Flete',
      icono: IconoTransporte.flete,
    ),
    ModalidadTransporte(
      id: 'express',
      titulo: 'Expreso Puerta a Puerta',
      descripcion: 'Directo sin paradas a finca o sector rural',
      detalle: 'Servicio exclusivo',
      precio: 4.00,
      nota: 'Tarifa',
      icono: IconoTransporte.expreso,
    ),
  ];

  static ModalidadTransporte porId(String id) => opciones.firstWhere(
    (ModalidadTransporte modalidad) => modalidad.id == id,
    orElse: () => opciones.first,
  );
}


class OpcionCarga {
  const OpcionCarga({
    required this.id,
    required this.nombre,
    required this.detalle,
    required this.adicional,
  });

  final String id;
  final String nombre;
  final String detalle;
  final double adicional;

  String get adicionalTexto => adicional == 0
      ? 'Incluido'
      : '+\$${adicional.toStringAsFixed(2)} adic.';

  static const List<OpcionCarga> opciones = <OpcionCarga>[
    OpcionCarga(
      id: 'none',
      nombre: 'Solo Pasajero',
      detalle: 'Sin carga adicional',
      adicional: 0,
    ),
    OpcionCarga(
      id: 'sacos',
      nombre: 'Sacos / Cosecha',
      detalle: 'Hasta 2 sacos de 50 kg',
      adicional: 0.50,
    ),
    OpcionCarga(
      id: 'bultos',
      nombre: 'Bultos Grandes',
      detalle: 'Balde completo del vehículo',
      adicional: 1.50,
    ),
  ];

  static OpcionCarga porId(String id) => opciones.firstWhere(
    (OpcionCarga opcion) => opcion.id == id,
    orElse: () => opciones.first,
  );
}


class DestinoFrecuente {
  const DestinoFrecuente({
    required this.nombre,
    required this.detalle,
    required this.ruta,
    this.origen = origenBaseCtm,
  });

  final String nombre;
  final String detalle;
  final String ruta;
  final String origen;

  static const List<DestinoFrecuente> frecuentes = <DestinoFrecuente>[
    DestinoFrecuente(
      nombre: 'Finca El Naranjal',
      detalle: 'Sector Río Verde • 24 km',
      ruta: 'Ruta 12',
    ),
    DestinoFrecuente(
      nombre: 'Mercado Central',
      detalle: 'Andén de carga y descarga',
      ruta: 'Urbano',
    ),
    DestinoFrecuente(
      nombre: 'Recinto San Gabriel',
      detalle: 'Cruce Las Mercedes • 42 km',
      ruta: 'Ruta 08',
    ),
    DestinoFrecuente(
      nombre: 'Parroquia San José',
      detalle: 'Parque central parroquial',
      ruta: 'Ruta 03',
    ),
  ];
}
