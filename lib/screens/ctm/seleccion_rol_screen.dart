import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/sesion/sesion.dart';
import '../../routes/app_routes.dart';
import '../../services/local/secure_storage_service.dart';
import '../../widgets/ui/ctm.dart';
import '../../widgets/ui/iconos_ctm.dart';
import 'sesion_ctm.dart';







class SeleccionRolScreen extends StatelessWidget {
  const SeleccionRolScreen({required this.sesion, super.key});

  final Sesion sesion;

  
  bool _habilitado(RolCtm panel) => switch (panel) {
    RolCtm.pasajero => true,
    RolCtm.conductor => sesion.rol == Rol.asociado,
    RolCtm.admin => sesion.rol.esPersonal,
  };

  
  String _motivo(RolCtm panel) => switch (panel) {
    RolCtm.pasajero => '',
    RolCtm.conductor => 'Requiere una cuenta de asociado',
    RolCtm.admin => 'Requiere una cuenta de gerente o asistente',
  };

  String _rutaDe(RolCtm panel) => switch (panel) {
    RolCtm.pasajero => AppRoutes.pasajero,
    RolCtm.conductor => AppRoutes.conductor,
    RolCtm.admin => AppRoutes.admin,
  };

  Future<void> _cerrarSesion(BuildContext context) async {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    await const SecureStorageService().clear();
  }

  void _entrar(BuildContext context, RolCtm panel) {
    if (!_habilitado(panel)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Tu rol actual (${sesion.etiquetaRol}) no puede abrir este panel.',
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: AppTheme.dark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    Navigator.of(
      context,
    ).pushReplacementNamed(_rutaDe(panel), arguments: sesion);
  }

  @override
  Widget build(BuildContext context) {
    return PaginaCtm(
      degradado: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[AppTheme.verde800, AppTheme.verdeProfundo],
      ),
      fondo: AppTheme.verde800,
      anchoMaximo: 430,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Center(child: LogoCtm(lado: 86)),
          const SizedBox(height: 16),
          const Text(
            'COOPERATIVA DE TRANSPORTES MIXTOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.verde100,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¿Cómo deseas ingresar?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppTheme.blanco,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Sesión de ${sesion.nombreVisible} · ${sesion.etiquetaRol}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.blanco.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 18),
          TarjetaCtm(
            radio: 18,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                for (final RolCtm panel in RolCtm.values) ...<Widget>[
                  _TarjetaRol(
                    panel: panel,
                    habilitado: _habilitado(panel),
                    motivo: _motivo(panel),
                    onTap: () => _entrar(context, panel),
                  ),
                  if (panel != RolCtm.values.last) const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: TextButton.icon(
              onPressed: () => _cerrarSesion(context),
              icon: const Icon(
                Icons.logout_rounded,
                size: 15,
                color: AppTheme.verde100,
              ),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.verde100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _TarjetaRol extends StatelessWidget {
  const _TarjetaRol({
    required this.panel,
    required this.habilitado,
    required this.motivo,
    required this.onTap,
  });

  final RolCtm panel;
  final bool habilitado;
  final String motivo;
  final VoidCallback onTap;

  String get _descripcion => switch (panel) {
    RolCtm.pasajero => 'Solicita viajes mixtos, carga y encomiendas.',
    RolCtm.conductor => 'Gestiona tu unidad, turno y solicitudes.',
    RolCtm.admin => 'Supervisa la flota y asigna despachos.',
  };

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: habilitado ? 1 : 0.55,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.blanco,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: habilitado ? AppTheme.border : AppTheme.divisor,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: panel.colorInsignia,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  panel.iniciales,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: panel.colorTextoInsignia,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          panel.nombre,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.titulo,
                          ),
                        ),
                        const SizedBox(width: 6),
                        PildoraCtm(
                          texto: panel.etiqueta,
                          fondo: panel.colorInsignia,
                          colorTexto: panel.colorTextoInsignia,
                          colorBorde: AppTheme.verde700.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      habilitado ? _descripcion : motivo,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppTheme.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                habilitado ? Icons.arrow_forward_rounded : Icons.lock_outline,
                size: 16,
                color: habilitado ? AppTheme.verde700 : AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
