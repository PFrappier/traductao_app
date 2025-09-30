import 'package:flutter/material.dart';

class AndalusianTheme {
  // Couleurs inspirées de l'Andalousie
  // Terracotta chaleureux pour les tons principaux
  static const Color _terracotta = Color(0xFFD4734B);
  static const Color _terracottaLight = Color(0xFFE89570);
  static const Color _terracottaDark = Color(0xFFB85A35);

  // Bleu méditerranéen profond
  static const Color _mediterraneanBlue = Color(0xFF2B5F82);

  // Tons chauds secondaires (ocre/sable)
  static const Color _warmSand = Color(0xFFE8C4A0);
  static const Color _ochre = Color(0xFFC9915D);

  // Tons neutres (blanc cassé andalou)
  static const Color _whitewash = Color(0xFFFAF7F2);

  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Couleurs principales - terracotta chaleureux
    primary: _terracotta,
    onPrimary: Colors.white,
    primaryContainer: _terracottaLight,
    onPrimaryContainer: _terracottaDark,

    // Couleurs secondaires - bleu méditerranéen
    secondary: _mediterraneanBlue,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFF4A7FA3),
    onSecondaryContainer: const Color(0xFF1A3D52),

    // Couleurs tertiaires - ocre/sable
    tertiary: _ochre,
    onTertiary: Colors.white,
    tertiaryContainer: _warmSand,
    onTertiaryContainer: const Color(0xFF7A5834),

    // Erreur
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: const Color(0xFFF9DEDC),
    onErrorContainer: const Color(0xFF8C1D18),

    // Fond
    surface: _whitewash,
    onSurface: const Color(0xFF201A17),
    surfaceContainerHighest: const Color(0xFFE8E1DC),
    onSurfaceVariant: const Color(0xFF51453E),

    // Bordures et contours
    outline: const Color(0xFF837469),
    outlineVariant: const Color(0xFFD2C5BB),

    // Ombres
    shadow: Colors.black,
    scrim: Colors.black,

    // Fond inversé
    inverseSurface: const Color(0xFF352F2B),
    onInverseSurface: const Color(0xFFF8EFE8),
    inversePrimary: _terracottaLight,
  );

  static ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Couleurs principales - terracotta adouci pour le mode sombre
    primary: _terracottaLight,
    onPrimary: const Color(0xFF5C2814),
    primaryContainer: _terracottaDark,
    onPrimaryContainer: const Color(0xFFFFDBCE),

    // Couleurs secondaires - bleu méditerranéen plus clair
    secondary: const Color(0xFF76B3D9),
    onSecondary: const Color(0xFF003549),
    secondaryContainer: _mediterraneanBlue,
    onSecondaryContainer: const Color(0xFFCAE6FF),

    // Couleurs tertiaires - sable/ocre adouci
    tertiary: _warmSand,
    onTertiary: const Color(0xFF4A3424),
    tertiaryContainer: const Color(0xFF8B6844),
    onTertiaryContainer: const Color(0xFFFFDDB8),

    // Erreur
    error: const Color(0xFFF2B8B5),
    onError: const Color(0xFF601410),
    errorContainer: const Color(0xFF8C1D18),
    onErrorContainer: const Color(0xFFF9DEDC),

    // Fond - tons chauds sombres
    surface: const Color(0xFF1C1613),
    onSurface: const Color(0xFFECE0D9),
    surfaceContainerHighest: const Color(0xFF3E362F),
    onSurfaceVariant: const Color(0xFFD2C5BB),

    // Bordures et contours
    outline: const Color(0xFF9B8E84),
    outlineVariant: const Color(0xFF51453E),

    // Ombres
    shadow: Colors.black,
    scrim: Colors.black,

    // Fond inversé
    inverseSurface: const Color(0xFFECE0D9),
    onInverseSurface: const Color(0xFF352F2B),
    inversePrimary: _terracotta,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: 'Roboto',
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: 'Roboto',
  );
}
