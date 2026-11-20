import 'package:flutter/material.dart';

import 'config/app_theme.dart';
import 'models/sesion/sesion.dart';
import 'routes/app_routes.dart';
import 'screens/ctm/conductor_panel_screen.dart';
import 'screens/ctm/inicio_pasajero_screen.dart';
import 'screens/ctm/seleccion_rol_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/login_screen.dart';
import 'screens/restablecer_contrasena_screen.dart';
import 'screens/splash_screen.dart';
import 'services/local/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sesion = await const SecureStorageService().readSesion();
  runApp(SitramixApp(sesionInicial: sesion, mostrarSplash: true));
}

class SitramixApp extends StatelessWidget {
  const SitramixApp({
    super.key,
    this.sesionInicial,
    this.mostrarSplash = false,
  });

  final Sesion? sesionInicial;

  final bool mostrarSplash;

  String get _rutaConSesion =>
      sesionInicial == null ? AppRoutes.login : AppRoutes.home;

  Sesion? _sesionDeRuta(Object? argumento) =>
      argumento is Sesion ? argumento : sesionInicial;

  Widget _pantallaSeleccion(Object? argumento) {
    final sesion = _sesionDeRuta(argumento);
    if (sesion == null) return const LoginScreen();
    return SeleccionRolScreen(sesion: sesion);
  }

  Widget _pantallaPasajero(Object? argumento) {
    final sesion = _sesionDeRuta(argumento);
    if (sesion == null) return const LoginScreen();
    return InicioPasajeroScreen(sesion: sesion);
  }

  Widget _pantallaConductor(Object? argumento) {
    final sesion = _sesionDeRuta(argumento);
    if (sesion == null) return const LoginScreen();
    return ConductorPanelScreen(sesion: sesion);
  }

  Widget _pantallaAdmin(Object? argumento) =>
      InicioScreen(sesionInicial: _sesionDeRuta(argumento));

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sitramix',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.tema,
    initialRoute: mostrarSplash ? AppRoutes.splash : _rutaConSesion,
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case AppRoutes.splash:
          return MaterialPageRoute(
            builder: (context) => SplashScreen(rutaSiguiente: _rutaConSesion),
          );
        case AppRoutes.login:
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        case AppRoutes.home:
          return MaterialPageRoute(
            builder: (context) => _pantallaSeleccion(settings.arguments),
          );
        case AppRoutes.pasajero:
          return MaterialPageRoute(
            builder: (context) => _pantallaPasajero(settings.arguments),
          );
        case AppRoutes.conductor:
          return MaterialPageRoute(
            builder: (context) => _pantallaConductor(settings.arguments),
          );
        case AppRoutes.admin:
          return MaterialPageRoute(
            builder: (context) => _pantallaAdmin(settings.arguments),
          );
        case AppRoutes.resetPassword:
          return MaterialPageRoute(
            builder: (context) => const ResetPasswordScreen(),
          );
        default:
          return MaterialPageRoute(builder: (context) => const LoginScreen());
      }
    },
  );
}
