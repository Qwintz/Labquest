import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static ThemeData get light => _generateFromScheme(
        const ColorScheme.light().copyWith(
          brightness: Brightness.light,
          primary: const Color(0xFF7371FC),
          onPrimary: const Color(0xFFF5F5F5),
          secondary: const Color(0xFF7371FC),
          onSecondary: const Color(0xFFF5F5F5),
          background: const Color(0xFFF5F5F5),
          onBackground: const Color(0xFF323232),
          surface: const Color(0xFFF5F5F5),
          onSurface: const Color(0xFF323232),
        ),
      );
  static ThemeData get dark => _generateFromScheme(
        const ColorScheme.dark().copyWith(
          brightness: Brightness.dark,
          primary: const Color(0xFF7371FC),
          onPrimary: const Color(0xFFF8F9FA),
          secondary: const Color(0xFF7371FC),
          onSecondary: const Color(0xFFF8F9FA),
          background: const Color(0xFF262626),
          onBackground: const Color(0xFFF8F9FA),
          surface: const Color(0xFF262626),
          onSurface: const Color(0xFFF8F9FA),
        ),
      );
  static ThemeData _generateFromScheme(ColorScheme colorScheme) {
    return ThemeData.from(colorScheme: colorScheme).copyWith(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: colorScheme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: colorScheme.background,
          systemNavigationBarIconBrightness:
              colorScheme.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onBackground,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.secondary,
      ),
      dialogTheme: DialogTheme(
        elevation: 0,
        backgroundColor: colorScheme.background,
      ),
    );
  }
}
