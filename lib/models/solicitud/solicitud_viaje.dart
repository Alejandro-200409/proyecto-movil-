import '../catalogo/catalogo_ctm.dart';


enum MetodoPago {
  efectivo('Efectivo al abordar', 'Cancelas directo al socio conductor'),
  transferencia(
    'Transferencia Directa CTM / Deuna QR',
    'Escanea el código en cabina o acreditación móvil',
  );

  const MetodoPago(this.titulo, this.detalle);

  final String titulo;
  final String detalle;
}






class SolicitudViaje {
  const SolicitudViaje({
    required this.origen,
    required this.destino,
    required this.modalidad,
    required this.carga,
    required this.metodoPago,
    this.inmediato = true,
    this.horaProgramada,
    this.notas = '',
    this.placaUnidad,
    this.conductor,
    this.despachoId,
  });

  final String origen;
  final String destino;
  final ModalidadTransporte modalidad;
  final OpcionCarga carga;
  final MetodoPago metodoPago;

  
  final bool inmediato;

  
  final String? horaProgramada;
  final String notas;

  
  final String? placaUnidad;
  final String? conductor;
  final int? despachoId;

  double get subtotal => modalidad.precio + carga.adicional;

  String get subtotalTexto => '\$${subtotal.toStringAsFixed(2)}';

  String get totalTexto => subtotalTexto;

  String get unidadTexto => (placaUnidad == null || placaUnidad!.isEmpty)
      ? 'Unidad por asignar'
      : 'Unidad #$placaUnidad';

  String get momentoTexto => inmediato
      ? 'Salida inmediata'
      : 'Programado para las ${horaProgramada ?? '--:--'}';

  String get codigoRecibo => despachoId == null
      ? 'CTM-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 10000}'
      : 'CTM-${DateTime.now().year}-$despachoId';

  
  SolicitudViaje conPago({
    required MetodoPago metodoPago,
    required bool inmediato,
    String? horaProgramada,
    required String notas,
  }) {
    return SolicitudViaje(
      origen: origen,
      destino: destino,
      modalidad: modalidad,
      carga: carga,
      metodoPago: metodoPago,
      inmediato: inmediato,
      horaProgramada: horaProgramada,
      notas: notas,
      placaUnidad: placaUnidad,
      conductor: conductor,
      despachoId: despachoId,
    );
  }

  
  SolicitudViaje conTransporte({
    required ModalidadTransporte modalidad,
    required OpcionCarga carga,
  }) {
    return SolicitudViaje(
      origen: origen,
      destino: destino,
      modalidad: modalidad,
      carga: carga,
      metodoPago: metodoPago,
      inmediato: inmediato,
      horaProgramada: horaProgramada,
      notas: notas,
      placaUnidad: placaUnidad,
      conductor: conductor,
      despachoId: despachoId,
    );
  }
}






final SolicitudViaje solicitudDemoCtm = SolicitudViaje(
  origen: origenBaseCtm,
  destino: 'Parroquia San José',
  modalidad: ModalidadTransporte.porId('truck'),
  carga: OpcionCarga.porId('sacos'),
  metodoPago: MetodoPago.efectivo,
  placaUnidad: 'PBA-4821',
  conductor: 'Manuel Ramos',
);
