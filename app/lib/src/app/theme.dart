import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

ThemeData buildMaterialTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.dark,
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF020817),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF020817),
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF0F172A),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
    ),
    dividerColor: const Color(0xFF1E293B),
  );
}

ShadThemeData buildShadTheme() {
  return ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadBlueColorScheme.dark(),
  );
}
