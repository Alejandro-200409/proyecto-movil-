import 'dart:async';

import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/ui/iconos_ctm.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.rutaSiguiente,
    this.duracion = const Duration(milliseconds: 900),
    super.key,
  });

  
  final String rutaSiguiente;

  
  final Duration duracion;

  
  static const version = '2.4.1';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _temporizador;
  bool _continuo = false;

  @override
  void initState() {
    super.initState();
    _temporizador = Timer(widget.duracion, _continuar);
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  
  
  void _continuar() {
    if (_continuo || !mounted) return;
    _continuo = true;
    _temporizador?.cancel();
    Navigator.of(context).pushReplacementNamed(widget.rutaSiguiente);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0E6B3D), Color(0xFF0A5230)],
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _continuar,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoCtm(lado: 132, padding: 14),
                      const SizedBox(height: 20),
                      const Column(
                        children: [
                          Text(
                            'CTM MÓVIL',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'COOPERATIVA DE TRANSPORTES MIXTOS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xCCFFFFFF),
                              letterSpacing: 1.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _punto(const Color(0x66FFFFFF)),
                          const SizedBox(width: 6),
                          _punto(AppTheme.mentaFuerte),
                          const SizedBox(width: 6),
                          _punto(const Color(0x66FFFFFF)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Text(
                  'v${SplashScreen.version} · Cooperativa CTM',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xCCFFFFFF),
                    letterSpacing: 0.36,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _punto(Color color) => Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
