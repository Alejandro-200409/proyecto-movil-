import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/login/login_request.dart';
import '../routes/app_routes.dart';
import '../services/local/secure_storage_service.dart';
import '../services/local/session_storage.dart';
import '../services/remote/api_service.dart';
import '../services/remote/login_service.dart';
import '../services/remote/nombre_usuario_service.dart';
import '../widgets/prototipo/proto_button.dart';
import '../widgets/prototipo/proto_field.dart';
import '../widgets/ui/ctm.dart';
import '../widgets/ui/iconos_ctm.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.servicio,
    this.almacenamiento,
    this.nombres,
  });

  
  
  final LoginService? servicio;
  final SessionStorage? almacenamiento;

  
  final NombreUsuarioService? nombres;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  static const double _anchoMaximo = 420;

  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginService _loginService = widget.servicio ?? LoginService();
  late final SessionStorage _sessionStorage =
      widget.almacenamiento ?? const SecureStorageService();
  late final NombreUsuarioService _nombreService =
      widget.nombres ?? NombreUsuarioService();

  bool _cargando = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  
  
  String? _validarUsuario(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Ingresa tu usuario.';
    return null;
  }

  String? _validarPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Ingresa tu contraseña.';
    return null;
  }

  Future<void> _login() async {
    if (_cargando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _cargando = true);
    try {
      final sesion = await _loginService.login(
        LoginRequest(
          username: _usuarioController.text.trim(),
          password: _passwordController.text,
        ),
      );
      if (!mounted) return;

      if (sesion.requiereCambioPassword) {
        _mostrarError(
          'Debes cambiar tu contraseña antes de continuar.',
          esError: false,
        );
        return;
      }

      await _sessionStorage.saveSesion(sesion);
      if (!mounted) return;

      final conNombre = await _nombreService.completar(sesion);
      if (!mounted) return;
      if (conNombre.nombres != sesion.nombres) {
        await _sessionStorage.saveSesion(conNombre);
        if (!mounted) return;
      }

      setState(() => _cargando = false);
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (_) => false,
        arguments: conNombre,
      );
    } on ApiException catch (error) {
      _mostrarError(
        error.body == null
            ? 'No se pudo iniciar sesión: error al conectar la API. '
                  '${error.message}'
            : 'No se pudo iniciar sesión. ${error.message}',
      );
    } catch (_) {
      _mostrarError('No se pudo iniciar sesión: error al conectar la API.');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _mostrarError(String mensaje, {bool esError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje, style: const TextStyle(fontSize: 11)),
          backgroundColor: esError ? AppTheme.dark : AppTheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }


  
  bool _mostrarClave = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _anchoMaximo),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _barraMarca(),
                    const SizedBox(height: 22),
                    _tarjetaAcceso(),
                    const SizedBox(height: 14),
                    _avisoSeguridad(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  
  Widget _barraMarca() => Row(
    children: [
      const LogoCtm(lado: 40, padding: 7),
      const SizedBox(width: 9),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CTM MÓVIL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppTheme.dark,
                letterSpacing: -0.2,
                height: 1.15,
              ),
            ),
            SizedBox(height: 1),
            Text(
              'TRANSPORTE MIXTO',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppTheme.muted,
                letterSpacing: 1,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
      const PildoraCtm(texto: 'Seguro', icono: Icons.shield_outlined),
    ],
  );

  
  Widget _tarjetaAcceso() => TarjetaCtm(
    radio: 22,
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const CajaIcono(Icons.person_outline_rounded, lado: 42),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.dark,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Ingresa con tu cuenta de cooperativa',
          style: TextStyle(fontSize: 12, color: AppTheme.muted),
        ),
        const SizedBox(height: 18),
        ProtoField(
          key: const ValueKey('login-usuario'),
          controller: _usuarioController,
          label: 'Usuario',
          hintText: 'usuario.apellido',
          icono: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          autocorrect: false,
          validator: _validarUsuario,
        ),
        const SizedBox(height: 12),
        ProtoField(
          key: const ValueKey('login-password'),
          controller: _passwordController,
          label: 'Contraseña',
          hintText: 'Tu contraseña',
          icono: Icons.lock_outline_rounded,
          esPassword: true,
          forzarVisible: _mostrarClave,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          autocorrect: false,
          validator: _validarPassword,
          onFieldSubmitted: (_) => _login(),
        ),
        const SizedBox(height: 2),
        _casillaMostrar(),
        const SizedBox(height: 14),
        ProtoButton(
          key: const ValueKey('login-enviar'),
          label: 'Iniciar sesión',
          icono: Icons.login_rounded,
          onPressed: _login,
          cargando: _cargando,
        ),
        const SizedBox(height: 6),
        Center(
          child: TextButton.icon(
            onPressed: _cargando
                ? null
                : () =>
                      Navigator.of(context).pushNamed(AppRoutes.resetPassword),
            icon: const Icon(Icons.help_outline_rounded, size: 15),
            label: const Text(
              '¿Olvidé mi contraseña?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );

  
  Widget _casillaMostrar() => Align(
    alignment: Alignment.centerLeft,
    child: InkWell(
      onTap: () => setState(() => _mostrarClave = !_mostrarClave),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _mostrarClave,
              onChanged: (valor) =>
                  setState(() => _mostrarClave = valor ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 2),
            const Flexible(
              child: Text(
                'Mostrar contraseña',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: AppTheme.dark),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  
  Widget _avisoSeguridad() => const AvisoCtm(
    titulo: 'Tu información está segura',
    texto: 'Sistema exclusivo para miembros de la Cooperativa',
    icono: Icons.verified_user_outlined,
  );
}
