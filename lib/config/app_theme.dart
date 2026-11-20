import 'package:flutter/material.dart';






class AppTheme {
  AppTheme._();

  static const Color verde900 = Color(0xFF003D23);
  static const Color verdeProfundo = Color(0xFF00331D);
  static const Color verde800 = Color(0xFF00552F);
  static const Color verde700 = Color(0xFF1E6F43);
  static const Color verde600 = Color(0xFF127C4B);
  static const Color verde100 = Color(0xFFB2F1C4);
  static const Color verdeMenta = Color(0xFFD6F8DF);

  static const Color surface = Color(0xFFF8FAF9);
  static const Color mutedSurface = Color(0xFFF2F4F3);
  static const Color blanco = Colors.white;
  static const Color border = Color(0x476F7A70);
  static const Color divisor = Color(0xFFE6E9E8);

  static const Color dark = Color(0xFF191C1C);
  static const Color titulo = Color(0xFF062D1B);
  static const Color textMuted = Color(0xFF66736A);
  static const Color textMedio = Color(0xFF3F4941);

  static const Color danger = Color(0xFFBA1A1A);
  static const Color dangerBg = Color(0xFFFFDAD6);
  static const Color dangerSurface = dangerBg;
  static const Color dangerBorder = Color(0xFFF5A09A);
  static const Color warning = Color(0xFFB54708);
  static const Color warningBg = Color(0xFFFFF6ED);
  static const Color warningSurface = warningBg;
  static const Color warningTexto = Color(0xFF7A2E03);
  static const Color warningBorder = Color(0xFFF5C08A);

  static const Color primary = verde800;
  static const Color secondary = verde900;
  static const Color menta = verde100;
  static const Color mentaFuerte = verdeMenta;
  static const Color bordeVerde = verde700;
  static const Color gray = surface;
  static const Color muted = textMuted;
  static const Color rule = border;
  static const Color navDivider = divisor;
  static const Color green = verde800;
  static const Color greenBg = verde100;
  static const Color greenBorder = verde700;
  static const Color red = danger;
  static const Color redBg = dangerBg;
  static const Color redBorder = dangerBorder;
  static const Color blue = verde600;
  static const Color amber = verde800;
  static const Color amberSuave = verde100;
  static const Color splash = verde900;
  static const Color white = blanco;

  static const String fontFamily = 'IBMPlexSans';
  static const double radioTarjeta = 12;
  static const double radioControl = 8;
  static const double anchoMaximo = 920;

  static const List<BoxShadow> sombra = <BoxShadow>[
    BoxShadow(
      color: Color(0x17175433),
      blurRadius: 16,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> sombraSuave = <BoxShadow>[
    BoxShadow(color: Color(0x0F175433), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static ThemeData get tema {
    final ColorScheme esquema = ColorScheme.fromSeed(
      seedColor: verde800,
      brightness: Brightness.light,
    ).copyWith(
      primary: verde800,
      onPrimary: blanco,
      primaryContainer: verde100,
      onPrimaryContainer: verde900,
      secondary: verde700,
      onSecondary: blanco,
      surface: blanco,
      onSurface: dark,
      surfaceContainerHighest: mutedSurface,
      outline: border,
      error: danger,
      onError: blanco,
    );

    const TextTheme textos = TextTheme(
      bodyLarge: TextStyle(fontSize: 14, color: dark, height: 1.4),
      bodyMedium: TextStyle(fontSize: 12, color: dark, height: 1.4),
      bodySmall: TextStyle(fontSize: 11, color: textMuted, height: 1.35),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: titulo,
        height: 1.15,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: dark,
      ),
      labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: esquema,
      scaffoldBackgroundColor: surface,
      canvasColor: surface,
      textTheme: textos.apply(fontFamily: fontFamily),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: titulo,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: titulo,
        ),
      ),
      iconTheme: const IconThemeData(color: verde800, size: 20),
      dividerTheme: const DividerThemeData(
        color: divisor,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: verde800,
        linearTrackColor: divisor,
        circularTrackColor: divisor,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark,
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          color: Colors.white,
        ),
        actionTextColor: verde100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioControl),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: blanco,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: titulo,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          color: textMedio,
          height: 1.45,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: blanco,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: divisor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: blanco,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          color: textMuted,
        ),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          color: textMuted,
        ),
        border: _borde(verde600),
        enabledBorder: _borde(border),
        focusedBorder: _borde(verde800, ancho: 1.4),
        errorBorder: _borde(danger),
        focusedErrorBorder: _borde(danger, ancho: 1.4),
        errorStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 10.5,
          color: danger,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: verde700, width: 1.4),
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> estados) =>
              estados.contains(WidgetState.selected) ? verde800 : blanco,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: verde700,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  static OutlineInputBorder _borde(Color color, {double ancho = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radioControl),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }
}
