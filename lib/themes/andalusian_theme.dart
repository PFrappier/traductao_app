import 'package:flutter/material.dart';

class AndalusianTheme {
  // Couleurs principales du thème andalou - Version expressive et vivace
  static const Color _primaryColor = Color(0xFF6B8E23); // Vert olive vif (olive drab)
  static const Color _onPrimary = Color(0xFFFFFFFF);
  static const Color _primaryContainer = Color(0xFFE8F5C8); // Vert olive très clair et lumineux
  static const Color _onPrimaryContainer = Color(0xFF1F2A08);
  
  static const Color _secondary = Color(0xFFFF7043); // Orange coral vibrant
  static const Color _onSecondary = Color(0xFFFFFFFF);
  static const Color _secondaryContainer = Color(0xFFFFE4DB);
  static const Color _onSecondaryContainer = Color(0xFF4A1C0A);
  
  static const Color _tertiary = Color(0xFF8D6E63); // Terre cuite chaude
  static const Color _onTertiary = Color(0xFFFFFFFF);
  static const Color _tertiaryContainer = Color(0xFFF3E5AB); // Beige doré lumineux
  static const Color _onTertiaryContainer = Color(0xFF2D1B00);
  
  static const Color _error = Color(0xFFBA1A1A);
  static const Color _onError = Color(0xFFFFFFFF);
  static const Color _errorContainer = Color(0xFFFFDAD6);
  static const Color _onErrorContainer = Color(0xFF410002);
  
  static const Color _surface = Color(0xFFFFF8F0); // Surface avec une pointe d'orange chaud
  static const Color _onSurface = Color(0xFF1F1612);
  static const Color _surfaceVariant = Color(0xFFF2E6D4); // Variant ocre clair
  static const Color _onSurfaceVariant = Color(0xFF4A3D32);
  
  static const Color _outline = Color(0xFF8B7355); // Outline dans les tons ocre
  static const Color _outlineVariant = Color(0xFFD4C4AD); // Plus clair, ocre
  
  static const Color _inverseSurface = Color(0xFF342A20); // Surface inverse ocre foncé
  static const Color _inverseOnSurface = Color(0xFFF7F0E7);
  static const Color _inversePrimary = Color(0xFFB8D788); // Vert olive lumineux pour le mode inversé
  
  static const Color _shadow = Color(0xFF000000);
  static const Color _surfaceTint = Color(0xFF6B8E23);
  static const Color _scrim = Color(0xFF000000);

  /// ColorScheme pour le mode clair
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primaryColor, // Vert olive principal
    onPrimary: _onPrimary,
    primaryContainer: _primaryContainer,
    onPrimaryContainer: _onPrimaryContainer,
    secondary: _secondary, // Orange secondaire
    onSecondary: _onSecondary,
    secondaryContainer: _secondaryContainer,
    onSecondaryContainer: _onSecondaryContainer,
    tertiary: _tertiary, // Terre cuite
    onTertiary: _onTertiary,
    tertiaryContainer: _tertiaryContainer,
    onTertiaryContainer: _onTertiaryContainer,
    error: _error,
    onError: _onError,
    errorContainer: _errorContainer,
    onErrorContainer: _onErrorContainer,
    surface: _surface,
    onSurface: _onSurface,
    surfaceVariant: _surfaceVariant,
    onSurfaceVariant: _onSurfaceVariant,
    outline: _outline,
    outlineVariant: _outlineVariant,
    shadow: _shadow,
    scrim: _scrim,
    inverseSurface: _inverseSurface,
    onInverseSurface: _inverseOnSurface,
    inversePrimary: _inversePrimary,
    surfaceTint: _surfaceTint,
  );

  /// ColorScheme pour le mode sombre (adapté)
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB8D788), // Vert olive lumineux pour le mode sombre
    onPrimary: Color(0xFF2A3511),
    primaryContainer: Color(0xFF405919),
    onPrimaryContainer: Color(0xFFE8F5C8),
    secondary: Color(0xFFFFAB91), // Orange coral clair
    onSecondary: Color(0xFF6B2C0F),
    secondaryContainer: Color(0xFF8A3F1A),
    onSecondaryContainer: Color(0xFFFFE4DB),
    tertiary: Color(0xFFD4B896), // Beige doré
    onTertiary: Color(0xFF3B2F24),
    tertiaryContainer: Color(0xFF523E32),
    onTertiaryContainer: Color(0xFFF3E5AB),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF1A1612), // Surface sombre avec base ocre
    onSurface: Color(0xFFF0E7DC),
    surfaceVariant: Color(0xFF4A3D32), // Variant ocre sombre
    onSurfaceVariant: Color(0xFFD4C4AD),
    outline: Color(0xFF9E8B73), // Outline ocre moyen
    outlineVariant: Color(0xFF4A3D32),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF0E7DC),
    onInverseSurface: Color(0xFF342A20),
    inversePrimary: Color(0xFF6B8E23),
    surfaceTint: Color(0xFFB8D788),
  );
}