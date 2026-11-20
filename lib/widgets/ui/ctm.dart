import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/sesion/sesion.dart';
import 'iconos_ctm.dart';






enum RolCtm {
  pasajero(
    nombre: 'Pasajero',
    etiqueta: 'PASAJERO',
    iniciales: 'CP',
    colorInsignia: AppTheme.verde100,
    colorTextoInsignia: AppTheme.verde900,
    tercero: 'Soporte',
    iconoTercero: IconosCtm.info,
  ),
  conductor(
    nombre: 'Conductor',
    etiqueta: 'SOCIO',
    iniciales: 'SC',
    colorInsignia: AppTheme.verdeMenta,
    colorTextoInsignia: AppTheme.verde800,
    tercero: 'Turno',
    iconoTercero: IconosCtm.turno,
  ),
  admin(
    nombre: 'Administración',
    etiqueta: 'ADMIN',
    iniciales: 'AD',
    colorInsignia: AppTheme.verdeMenta,
    colorTextoInsignia: AppTheme.verde800,
    tercero: 'Gestión',
    iconoTercero: IconosCtm.gestion,
  );

  const RolCtm({
    required this.nombre,
    required this.etiqueta,
    required this.iniciales,
    required this.colorInsignia,
    required this.colorTextoInsignia,
    required this.tercero,
    required this.iconoTercero,
  });

  final String nombre;
  final String etiqueta;
  final String iniciales;
  final Color colorInsignia;
  final Color colorTextoInsignia;

  
  final String tercero;
  final String iconoTercero;
}


extension PanelDeRolSesion on Rol {
  RolCtm get panelCtm => switch (this) {
    Rol.asociado => RolCtm.conductor,
    Rol.gerente || Rol.asistente => RolCtm.admin,
    Rol.desconocido => RolCtm.pasajero,
  };

  
  bool get esPersonal => this == Rol.gerente || this == Rol.asistente;
}



class PaginaCtm extends StatelessWidget {
  const PaginaCtm({
    required this.child,
    this.encabezado,
    this.navegacion,
    this.degradado,
    this.anchoMaximo = AppTheme.anchoMaximo,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 24),
    this.scrollable = true,
    this.fondo,
    super.key,
  });

  final Widget child;
  final Widget? encabezado;
  final Widget? navegacion;
  final Gradient? degradado;
  final double anchoMaximo;
  final EdgeInsets padding;
  final bool scrollable;
  final Color? fondo;

  @override
  Widget build(BuildContext context) {
    Widget contenido = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: anchoMaximo),
        child: Padding(padding: padding, child: child),
      ),
    );
    if (scrollable) {
      contenido = SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: contenido,
      );
    }

    return Scaffold(
      backgroundColor: fondo ?? AppTheme.surface,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: degradado),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              ?encabezado,
              Expanded(child: contenido),
              ?navegacion,
            ],
          ),
        ),
      ),
    );
  }
}



class EncabezadoCtm extends StatelessWidget {
  const EncabezadoCtm({
    this.rol = RolCtm.pasajero,
    this.onMenu,
    this.onPerfil,
    this.titulo,
    this.subtitulo,
    this.marca = true,
    super.key,
  });

  final RolCtm rol;
  final VoidCallback? onMenu;
  final VoidCallback? onPerfil;
  final String? titulo;
  final String? subtitulo;
  final bool marca;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.blanco,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: <Widget>[
          BotonIconoCtm(onTap: onMenu ?? () {}, icono: IconosCtm.menu),
          const SizedBox(width: 10),
          Expanded(
            child: marca
                ? Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.verde800,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'CTM',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.blanco,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              titulo ?? 'CTM Móvil',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.titulo,
                                height: 1.1,
                              ),
                            ),
                            const Text(
                              'Cooperativa de Transporte Mixto',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 8,
                                color: AppTheme.textMuted,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(
                    titulo ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.titulo,
                    ),
                  ),
          ),
          if (subtitulo != null) ...<Widget>[
            Text(
              subtitulo!,
              style: const TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.verde700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: rol.colorInsignia,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              rol.etiqueta,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: rol.colorTextoInsignia,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: AppTheme.verde700,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPerfil,
              child: SizedBox(
                width: 31,
                height: 31,
                child: Center(
                  child: Text(
                    rol.iniciales,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.blanco,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BarraFlujoCtm extends StatelessWidget {
  const BarraFlujoCtm({
    required this.eyebrow,
    required this.titulo,
    this.detalle,
    this.onAtras,
    this.accion,
    super.key,
  });

  final String eyebrow;
  final String titulo;
  final String? detalle;
  final VoidCallback? onAtras;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
      decoration: const BoxDecoration(
        color: AppTheme.blanco,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: <Widget>[
          BotonIconoCtm(
            redondo: true,
            iconoMaterial: Icons.arrow_back_rounded,
            onTap: onAtras ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  eyebrow.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.verde700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titulo,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          if (accion != null) ...<Widget>[const SizedBox(width: 8), accion!],
          if (detalle != null)
            Text(
              detalle!,
              style: const TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}


class BotonIconoCtm extends StatelessWidget {
  const BotonIconoCtm({
    this.onTap,
    this.icono,
    this.iconoMaterial,
    this.fondo = AppTheme.mutedSurface,
    this.color,
    this.redondo = false,
    this.lado = 34,
    super.key,
  });

  final VoidCallback? onTap;
  final String? icono;
  final IconData? iconoMaterial;
  final Color fondo;
  final Color? color;
  final bool redondo;
  final double lado;

  @override
  Widget build(BuildContext context) {
    final Color tinte = color ?? AppTheme.verde800;
    return Material(
      color: fondo,
      borderRadius: redondo ? null : BorderRadius.circular(9),
      shape: redondo ? const CircleBorder() : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: SizedBox(
          width: lado,
          height: lado,
          child: Center(
            child: icono != null
                ? IconoCtm(
                    icono!,
                    ancho: lado * 0.47,
                    alto: lado * 0.47,
                    color: tinte,
                  )
                : Icon(iconoMaterial, size: lado * 0.5, color: tinte),
          ),
        ),
      ),
    );
  }
}


class BarraNavegacionCtm extends StatelessWidget {
  const BarraNavegacionCtm({
    required this.rol,
    required this.activo,
    this.onInicio,
    this.onViajes,
    this.onTercero,
    this.onPerfil,
    super.key,
  });

  final RolCtm rol;

  
  final String activo;
  final VoidCallback? onInicio;
  final VoidCallback? onViajes;
  final VoidCallback? onTercero;
  final VoidCallback? onPerfil;

  @override
  Widget build(BuildContext context) {
    final List<_ItemNav> items = <_ItemNav>[
      _ItemNav('Inicio', IconosCtm.inicio, activo == 'inicio', onInicio),
      _ItemNav('Viajes', IconosCtm.viajes, activo == 'viajes', onViajes),
      _ItemNav(rol.tercero, rol.iconoTercero, activo == 'tercero', onTercero),
      _ItemNav('Perfil', IconosCtm.menu, activo == 'perfil', onPerfil),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.blanco,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: <Widget>[
              for (final _ItemNav item in items)
                Expanded(child: _ItemNavCtm(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemNav {
  const _ItemNav(this.etiqueta, this.icono, this.activo, this.onTap);

  final String etiqueta;
  final String icono;
  final bool activo;
  final VoidCallback? onTap;
}

class _ItemNavCtm extends StatelessWidget {
  const _ItemNavCtm({required this.item});

  final _ItemNav item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap ?? () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: item.activo
              ? AppTheme.verde100.withValues(alpha: 0.55)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconoCtm(
              item.icono,
              ancho: 20,
              alto: 20,
              color: item.activo ? AppTheme.verde900 : AppTheme.verde700,
            ),
            const SizedBox(height: 2),
            Text(
              item.etiqueta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: item.activo ? FontWeight.w800 : FontWeight.w600,
                color: item.activo ? AppTheme.verde900 : AppTheme.verde700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



enum VarianteBoton { primario, contorno, peligro, fantasma }


class BotonCtm extends StatelessWidget {
  const BotonCtm({
    required this.texto,
    this.onPressed,
    this.variante = VarianteBoton.primario,
    this.icono,
    this.cargando = false,
    this.expandido = false,
    this.altura = 44,
    this.tamanoTexto = 13,
    super.key,
  });

  final String texto;
  final VoidCallback? onPressed;
  final VarianteBoton variante;
  final Widget? icono;
  final bool cargando;
  final bool expandido;
  final double altura;
  final double tamanoTexto;

  @override
  Widget build(BuildContext context) {
    final (Color fondo, Color borde, Color colorTexto) = switch (variante) {
      VarianteBoton.primario => (
        AppTheme.verde800,
        AppTheme.verde800,
        AppTheme.blanco,
      ),
      VarianteBoton.contorno => (
        AppTheme.blanco,
        AppTheme.verde700,
        AppTheme.verde800,
      ),
      VarianteBoton.peligro => (
        AppTheme.danger,
        AppTheme.danger,
        AppTheme.blanco,
      ),
      VarianteBoton.fantasma => (
        Colors.transparent,
        Colors.transparent,
        AppTheme.verde700,
      ),
    };
    final bool activo = onPressed != null && !cargando;
    final bool solido =
        variante == VarianteBoton.primario || variante == VarianteBoton.peligro;

    final Widget contenido = cargando
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorTexto),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icono != null) ...<Widget>[icono!, const SizedBox(width: 6)],
              Flexible(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: tamanoTexto,
                    fontWeight: FontWeight.w700,
                    color: activo
                        ? colorTexto
                        : colorTexto.withValues(alpha: 0.5),
                    letterSpacing: 0.2,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          );

    return Opacity(
      opacity: activo ? 1 : 0.75,
      child: Material(
        color: activo
            ? fondo
            : (solido ? fondo.withValues(alpha: 0.5) : fondo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radioControl),
          side: BorderSide(
            color: solido || !activo ? Colors.transparent : borde,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: activo ? onPressed : null,
          child: Container(
            height: altura,
            width: expandido ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            child: contenido,
          ),
        ),
      ),
    );
  }
}


class TarjetaCtm extends StatelessWidget {
  const TarjetaCtm({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radio = AppTheme.radioTarjeta,
    this.onTap,
    this.colorFondo = AppTheme.blanco,
    this.colorBorde = AppTheme.border,
    this.sombra = AppTheme.sombra,
    this.anchoBorde = 1,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radio;
  final VoidCallback? onTap;
  final Color colorFondo;
  final Color colorBorde;
  final List<BoxShadow> sombra;
  final double anchoBorde;

  @override
  Widget build(BuildContext context) {
    final Widget tarjeta = Container(
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(radio),
        border: Border.all(color: colorBorde, width: anchoBorde),
        boxShadow: sombra,
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return tarjeta;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radio),
        child: tarjeta,
      ),
    );
  }
}


class PildoraCtm extends StatelessWidget {
  const PildoraCtm({
    required this.texto,
    this.fondo = const Color(0x8CB2F1C4),
    this.colorTexto = AppTheme.verde800,
    this.colorBorde = const Color(0x401E6F43),
    this.icono,
    super.key,
  });

  final String texto;
  final Color fondo;
  final Color colorTexto;
  final Color colorBorde;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: colorBorde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icono != null) ...<Widget>[
            Icon(icono, size: 10, color: colorTexto),
            const SizedBox(width: 3),
          ],
          Text(
            texto,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: colorTexto,
              letterSpacing: 0.3,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}


class TituloSeccion extends StatelessWidget {
  const TituloSeccion({
    required this.titulo,
    this.descripcion,
    this.detalle,
    this.accion,
    this.icono,
    super.key,
  });

  final String titulo;
  final String? descripcion;
  final String? detalle;
  final Widget? accion;
  final String? icono;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (icono != null) ...<Widget>[
              IconoCtm(icono!, ancho: 15, alto: 15),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.titulo,
                  height: 1.2,
                ),
              ),
            ),
            if (detalle != null)
              Text(
                detalle!,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.4,
                ),
              ),
            if (accion != null) ...<Widget>[const SizedBox(width: 6), accion!],
          ],
        ),
        if (descripcion != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              descripcion!,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppTheme.textMuted,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}


class BarraProgreso extends StatelessWidget {
  const BarraProgreso({
    required this.valor,
    this.alto = 4,
    this.color = AppTheme.verde800,
    this.fondo = AppTheme.divisor,
    super.key,
  });

  final double valor;
  final double alto;
  final Color color;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(alto),
      child: LinearProgressIndicator(
        value: valor.clamp(0, 1),
        minHeight: alto,
        backgroundColor: fondo,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}


class BannerPaso extends StatelessWidget {
  const BannerPaso({
    required this.numero,
    required this.titulo,
    required this.paso,
    this.progreso,
    super.key,
  });

  final int numero;
  final String titulo;

  
  final String paso;
  final double? progreso;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 12, 10),
      decoration: BoxDecoration(
        color: AppTheme.verde600.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.verde700.withValues(alpha: 0.16)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppTheme.verde800,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$numero',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.blanco,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.titulo,
                  ),
                ),
              ),
              Text(
                paso,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          if (progreso != null) ...<Widget>[
            const SizedBox(height: 8),
            BarraProgreso(valor: progreso!, alto: 3),
          ],
        ],
      ),
    );
  }
}


class HitoLinea {
  const HitoLinea({
    required this.etiqueta,
    required this.titulo,
    this.detalle,
    this.activo = false,
  });

  final String etiqueta;
  final String titulo;
  final String? detalle;
  final bool activo;
}


class LineaTiempo extends StatelessWidget {
  const LineaTiempo({
    required this.hitos,
    this.colorLinea = AppTheme.divisor,
    this.radio,
    this.padding,
    super.key,
  });

  final List<HitoLinea> hitos;
  final Color colorLinea;

  
  final double? radio;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final Widget contenido = IntrinsicHeight(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 5,
            top: 8,
            bottom: 8,
            child: Container(width: 2, color: colorLinea),
          ),
          Column(
            children: <Widget>[
              for (int i = 0; i < hitos.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == hitos.length - 1 ? 0 : 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hitos[i].activo
                              ? AppTheme.verde800
                              : AppTheme.blanco,
                          border: Border.all(
                            color: hitos[i].activo
                                ? AppTheme.verde800
                                : AppTheme.verde700,
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              hitos[i].etiqueta.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textMuted,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              hitos[i].titulo,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.dark,
                              ),
                            ),
                            if (hitos[i].detalle != null)
                              Text(
                                hitos[i].detalle!,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (radio == null && padding == null) return contenido;
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.mutedSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(radio ?? 8),
      ),
      child: contenido,
    );
  }
}


class SegmentadoCtm extends StatelessWidget {
  const SegmentadoCtm({
    required this.opciones,
    required this.seleccion,
    required this.onCambio,
    super.key,
  });

  final List<String> opciones;
  final int seleccion;
  final ValueChanged<int> onCambio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.mutedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < opciones.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onCambio(i),
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == seleccion
                        ? AppTheme.blanco
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: i == seleccion ? AppTheme.sombraSuave : null,
                  ),
                  child: Text(
                    opciones[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: i == seleccion
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: i == seleccion
                          ? AppTheme.verde900
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class CampoTexto extends StatelessWidget {
  const CampoTexto({
    this.controller,
    this.hint,
    this.icono,
    this.iconoAsset,
    this.sufijo,
    this.prefijo,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.altura = 46,
    this.foco,
    this.teclado,
    this.maxLineas = 1,
    this.autofocus = false,
    this.oscuro = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? icono;
  final String? iconoAsset;
  final Widget? sufijo;
  final Widget? prefijo;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final double altura;
  final FocusNode? foco;
  final TextInputType? teclado;
  final int maxLineas;
  final bool autofocus;

  
  final bool oscuro;

  @override
  Widget build(BuildContext context) {
    final Color colorTexto = oscuro ? AppTheme.blanco : AppTheme.dark;
    final Color colorHint = oscuro
        ? AppTheme.blanco.withValues(alpha: 0.65)
        : AppTheme.textMuted;

    return Container(
      constraints: BoxConstraints(minHeight: altura),
      padding: EdgeInsets.symmetric(
        horizontal: 11,
        vertical: maxLineas > 1 ? 8 : 0,
      ),
      decoration: BoxDecoration(
        color: oscuro ? AppTheme.verde900 : AppTheme.blanco,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: oscuro ? AppTheme.verde700 : AppTheme.border),
      ),
      child: Row(
        children: <Widget>[
          if (prefijo != null) ...<Widget>[prefijo!, const SizedBox(width: 8)],
          if (iconoAsset != null) ...<Widget>[
            IconoCtm(
              iconoAsset!,
              ancho: 16,
              alto: 16,
              color: oscuro ? AppTheme.verde100 : AppTheme.verde700,
            ),
            const SizedBox(width: 8),
          ],
          if (icono != null) ...<Widget>[
            Icon(
              icono,
              size: 17,
              color: oscuro ? AppTheme.verde100 : AppTheme.verde700,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: foco,
              enabled: enabled,
              autofocus: autofocus,
              keyboardType: teclado,
              maxLines: maxLineas,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              cursorColor: AppTheme.verde700,
              style: TextStyle(fontSize: 12.5, color: colorTexto, height: 1.35),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 12.5,
                  color: colorHint,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (sufijo != null) ...<Widget>[const SizedBox(width: 6), sufijo!],
        ],
      ),
    );
  }
}


class BotonOpcion extends StatelessWidget {
  const BotonOpcion({
    required this.child,
    this.onTap,
    this.activo = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    this.radio = 6,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool activo;
  final EdgeInsets padding;
  final double radio;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activo ? AppTheme.verde800.withValues(alpha: 0.07) : AppTheme.blanco,
      borderRadius: BorderRadius.circular(radio),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radio),
            border: Border.all(
              color: activo ? AppTheme.verde800 : AppTheme.border,
              width: activo ? 1.4 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}




class CajaIcono extends StatelessWidget {
  const CajaIcono(
    this.icono, {
    this.ruta,
    this.lado = 34,
    this.fondo = AppTheme.verde100,
    this.color,
    this.redondo = true,
    super.key,
  });

  final IconData icono;

  
  final String? ruta;
  final double lado;
  final Color fondo;
  final Color? color;
  final bool redondo;

  @override
  Widget build(BuildContext context) {
    final Color tinte = color ?? AppTheme.verde800;
    return Container(
      width: lado,
      height: lado,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fondo,
        shape: redondo ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: redondo ? null : BorderRadius.circular(9),
        border: Border.all(color: AppTheme.verde700.withValues(alpha: 0.2)),
      ),
      child: ruta != null
          ? IconoCtm(ruta!, ancho: lado * 0.5, alto: lado * 0.5, color: tinte)
          : Icon(icono, size: lado * 0.5, color: tinte),
    );
  }
}


class FilaDato extends StatelessWidget {
  const FilaDato({
    required this.etiqueta,
    required this.valor,
    this.destacado = false,
    this.colorValor,
    this.icono,
    super.key,
  });

  final String etiqueta;
  final String valor;
  final bool destacado;
  final Color? colorValor;
  final String? icono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icono != null) ...<Widget>[
            IconoCtm(icono!, ancho: 13, alto: 13),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              etiqueta,
              style: TextStyle(
                fontSize: destacado ? 12.5 : 11,
                fontWeight: destacado ? FontWeight.w800 : FontWeight.w500,
                color: destacado ? AppTheme.titulo : AppTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: destacado ? 13.5 : 11.5,
                fontWeight: destacado ? FontWeight.w800 : FontWeight.w700,
                color:
                    colorValor ??
                    (destacado ? AppTheme.verde800 : AppTheme.titulo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


enum TipoAviso { info, exito, advertencia, error }

class AvisoCtm extends StatelessWidget {
  const AvisoCtm({
    required this.texto,
    this.tipo = TipoAviso.info,
    this.titulo,
    this.icono,
    super.key,
  });

  final String texto;
  final TipoAviso tipo;
  final String? titulo;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final (Color fondo, Color borde, Color colorTexto, IconData iconoBase) =
        switch (tipo) {
          TipoAviso.info => (
            AppTheme.verde600.withValues(alpha: 0.08),
            AppTheme.verde700.withValues(alpha: 0.25),
            AppTheme.verde900,
            Icons.info_outline_rounded,
          ),
          TipoAviso.exito => (
            AppTheme.verde100.withValues(alpha: 0.75),
            AppTheme.verde700.withValues(alpha: 0.4),
            AppTheme.verde900,
            Icons.check_circle_outline_rounded,
          ),
          TipoAviso.advertencia => (
            AppTheme.warningSurface,
            AppTheme.warning.withValues(alpha: 0.35),
            AppTheme.warningTexto,
            Icons.warning_amber_rounded,
          ),
          TipoAviso.error => (
            AppTheme.dangerSurface,
            AppTheme.danger.withValues(alpha: 0.3),
            AppTheme.danger,
            Icons.error_outline_rounded,
          ),
        };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borde),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icono ?? iconoBase, size: 16, color: colorTexto),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (titulo != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      titulo!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: colorTexto,
                      ),
                    ),
                  ),
                Text(
                  texto,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: colorTexto,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class FichaMetrica extends StatelessWidget {
  const FichaMetrica({
    required this.etiqueta,
    required this.valor,
    this.detalle,
    this.icono,
    this.colorValor = AppTheme.verde900,
    this.fondoIcono = AppTheme.verde100,
    super.key,
  });

  final String etiqueta;
  final String valor;
  final String? detalle;
  final String? icono;
  final Color colorValor;
  final Color fondoIcono;

  @override
  Widget build(BuildContext context) {
    return TarjetaCtm(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icono != null)
                CajaIcono(
                  Icons.local_shipping_outlined,
                  ruta: icono,
                  lado: 22,
                  fondo: fondoIcono,
                  redondo: false,
                ),
              if (icono != null) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  etiqueta.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colorValor,
              height: 1.1,
            ),
          ),
          if (detalle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                detalle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class CargandoCtm extends StatelessWidget {
  const CargandoCtm({this.mensaje, this.padding = const EdgeInsets.all(24), super.key});

  final String? mensaje;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.verde700),
              ),
            ),
            if (mensaje != null) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                mensaje!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class MensajeErrorCtm extends StatelessWidget {
  const MensajeErrorCtm({
    required this.mensaje,
    this.onReintentar,
    this.titulo = 'No pudimos cargar la información',
    super.key,
  });

  final String mensaje;
  final VoidCallback? onReintentar;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return TarjetaCtm(
      colorFondo: AppTheme.dangerSurface,
      colorBorde: AppTheme.danger.withValues(alpha: 0.3),
      sombra: const <BoxShadow>[],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.error_outline_rounded,
                size: 17,
                color: AppTheme.danger,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.danger,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.danger,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onReintentar != null) ...<Widget>[
            const SizedBox(height: 10),
            BotonCtm(
              texto: 'Reintentar',
              variante: VarianteBoton.contorno,
              altura: 36,
              tamanoTexto: 11.5,
              icono: const Icon(
                Icons.refresh_rounded,
                size: 15,
                color: AppTheme.verde800,
              ),
              onPressed: onReintentar,
            ),
          ],
        ],
      ),
    );
  }
}


class EstadoVacioCtm extends StatelessWidget {
  const EstadoVacioCtm({
    required this.titulo,
    required this.mensaje,
    this.icono,
    this.iconoMaterial = Icons.inbox_rounded,
    this.accion,
    super.key,
  });

  final String titulo;
  final String mensaje;
  final String? icono;
  final IconData iconoMaterial;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CajaIcono(
            iconoMaterial,
            ruta: icono,
            lado: 42,
            fondo: AppTheme.mutedSurface,
            color: AppTheme.verde700,
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppTheme.titulo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),
          if (accion != null) ...<Widget>[
            const SizedBox(height: 12),
            accion!,
          ],
        ],
      ),
    );
  }
}
