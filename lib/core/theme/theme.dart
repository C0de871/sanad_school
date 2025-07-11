// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";

class AppTheme {
  static AppColor colorScheme = AppColor.BLUE;
  static final LightBlueColors _lightBlueColors = LightBlueColors();
  static final DarkBlueColors _darkBlueColors = DarkBlueColors();

  AppTheme();

  //! Light Mode:
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff415e91),
      surfaceTint: Color(0xff415e91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd7e3ff),
      onPrimaryContainer: Color(0xff284777),
      secondary: Color(0xff565e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdae2f9),
      onSecondaryContainer: Color(0xff3e4759),
      tertiary: Color(0xff705574),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffad8fd),
      onTertiaryContainer: Color(0xff573e5c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff44474e),
      outline: Color(0xff74777f),
      outlineVariant: Color(0xffc4c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff284777),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2b),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff28132e),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff573e5c),
      surfaceDim: Color(0xffd9d9e0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() {
    return _theme(lightScheme());
  }

  // ================================================

  //! Light Medium Contrast Mode:
  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff143665),
      surfaceTint: Color(0xff415e91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff506da0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2e3647),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff646d80),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff452e4a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7f6484),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0f1116),
      onSurfaceVariant: Color(0xff33363e),
      outline: Color(0xff4f525a),
      outlineVariant: Color(0xff6a6d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff506da0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff375586),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff646d80),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c5567),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f6484),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff664c6a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6cd),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffe7e8ee),
      surfaceContainerHigh: Color(0xffdcdce3),
      surfaceContainerHighest: Color(0xffd1d1d8),
    );
  }

  ThemeData lightMediumContrast() {
    return _theme(lightMediumContrastScheme());
  }

//=============================================================

  //! light High Contrast Mode:
  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff042b5b),
      surfaceTint: Color(0xff415e91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2b497a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff242c3d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff41495b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a2440),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff59405e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c33),
      outlineVariant: Color(0xff464951),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff2b497a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0f3262),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff41495b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2a3344),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff59405e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff412a47),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8b8bf),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f0f7),
      surfaceContainer: Color(0xffe2e2e9),
      surfaceContainerHigh: Color(0xffd4d4db),
      surfaceContainerHighest: Color(0xffc5c6cd),
    );
  }

  ThemeData lightHighContrast() {
    return _theme(lightHighContrastScheme());
  }

//==========================================================================

  //! dark mode:
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaac7ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff0b305f),
      primaryContainer: Color(0xff284777),
      onPrimaryContainer: Color(0xffd7e3ff),
      secondary: Color(0xffbec6dc),
      onSecondary: Color(0xff283141),
      secondaryContainer: Color(0xff3e4759),
      onSecondaryContainer: Color(0xffdae2f9),
      tertiary: Color(0xffddbce0),
      onTertiary: Color(0xff3f2844),
      tertiaryContainer: Color(0xff573e5c),
      onTertiaryContainer: Color(0xfffad8fd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff415e91),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff284777),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2b),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff28132e),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff573e5c),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1e2025),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData dark() {
    return _theme(darkScheme());
  }

  // ================================================

  //! dark medium contrast Mode:
  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002551),
      primaryContainer: Color(0xff7491c7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd4dcf2),
      onSecondary: Color(0xff1d2636),
      secondaryContainer: Color(0xff8891a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3d2f7),
      onTertiary: Color(0xff331d39),
      tertiaryContainer: Color(0xffa587a9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadce6),
      outline: Color(0xffafb1bb),
      outlineVariant: Color(0xff8e9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294879),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff143665),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff081121),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff2e3647),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff1d0823),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff452e4a),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff43444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1b1e22),
      surfaceContainer: Color(0xff26282d),
      surfaceContainerHigh: Color(0xff313238),
      surfaceContainerHighest: Color(0xff3c3e43),
    );
  }

  ThemeData darkMediumContrast() {
    return _theme(darkMediumContrastScheme());
  }

// ================================================

  //! dark high contrast Mode:
  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa6c3fc),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffebf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbac3d8),
      onSecondaryContainer: Color(0xff030b1a),
      tertiary: Color(0xffffeafe),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd9b8dc),
      onTertiaryContainer: Color(0xff17031d),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeeeff9),
      outlineVariant: Color(0xffc0c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294879),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff081121),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff1d0823),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff4e5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e2025),
      surfaceContainer: Color(0xff2e3036),
      surfaceContainerHigh: Color(0xff393b41),
      surfaceContainerHighest: Color(0xff45474c),
    );
  }

  ThemeData darkHighContrast() {
    return _theme(darkHighContrastScheme());
  }

  // ================================================

  ThemeData _theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        fontFamily: 'Cairo',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: extendedColorofBrightness(colorScheme.brightness).border,
                width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      );

  static ExtendedColors extendedColorOf(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return _getExtendedColors(isDark);
  }

  static ExtendedColors extendedColorofBrightness(Brightness brightness) {
    bool isDark = brightness == Brightness.dark ? true : false;
    return _getExtendedColors(isDark);
  }

  static ExtendedColors _getExtendedColors(bool isDark) {
    if (isDark) {
      switch (colorScheme) {
        case AppColor.BLUE:
          return _darkBlueColors;
      }
    } else {
      switch (colorScheme) {
        case AppColor.BLUE:
          return _lightBlueColors;
      }
    }
  }
}

enum AppColor {
  BLUE,
}

abstract class ExtendedColors {
  Color get buttonShadow;
  Color get border;
  Color get white;
  Color get gradientEndColor;
  Color get gradientGreen;
  Color get gradientBlue;
  Color get gradientPurple;
  Color get gradientPink;
  Color get gradientIndigo;
  Color get gradientOrange;
  Color get gradientBrown;
  Color get gradientBlueGrey;
  Color get gradientTeal;
  Color get answerCard;

  // Blue theme colors
  Color get blueShadowColor;
  Color get blueTextColor;
  Color get blueBackgroundColor;

  // Red theme colors
  Color get redShadowColor;
  Color get redTextColor;
  Color get redBackgroundColor;

  // Green theme colors
  Color get greenShadowColor;
  Color get greenTextColor;
  Color get greenBackgroundColor;
}

class LightBlueColors extends ExtendedColors {
  @override
  final Color buttonShadow = Color.fromARGB(255, 22, 47, 89);
  // 1, 1/3, 1/2, 0.61

  @override
  final Color border = Color(0xff007abc);

  @override
  final Color white = Colors.white;

  @override
  final Color gradientEndColor = Color(0xFF1A1B1F);

  @override
  final Color gradientGreen = Color(0xFF4CAF50);

  @override
  final Color gradientBlue = Color(0xFF2196F3);

  @override
  final Color gradientPurple = Color(0xFF9C27B0);

  @override
  final Color gradientPink = Color(0xFFE91E63);

  @override
  final Color gradientIndigo = Color(0xFF3F51B5);

  @override
  final Color gradientOrange = Color(0xFFFF5722);

  @override
  final Color gradientBrown = Color(0xFF795548);

  @override
  final Color gradientBlueGrey = Color(0xFF607D8B);

  @override
  final Color gradientTeal = Color(0xFF009688);

  @override
  final Color answerCard =Color.fromARGB(255, 233, 236, 242);

  // Light mode theme colors
  @override
  final Color blueShadowColor = Color(0xFF84D6FD);

  @override
  final Color blueTextColor = Color.fromARGB(255, 91, 203, 255);

  @override
  final Color blueBackgroundColor = Color(0xFFDDF3FE);

  @override
  final Color redShadowColor = Color.fromARGB(255, 254, 117, 117);

  @override
  final Color redTextColor = Color.fromARGB(255, 242, 89, 89);

  @override
  final Color redBackgroundColor = Color(0xFFFFDFE0);

  @override
  final Color greenShadowColor = Color(0xFFA7EF75);

  @override
  final Color greenTextColor = Color.fromARGB(255, 69, 165, 0);

  @override
  final Color greenBackgroundColor = Color(0xFFD7FFB8);
}

class DarkBlueColors extends ExtendedColors {
  @override
  final Color buttonShadow = Color.fromARGB(255, 117, 157, 237);

  @override
  final Color border = Color(0xff2f97df);

  @override
  final Color white = Colors.white;

  @override
  final Color gradientEndColor = Color(0xFF1A1B1F);

  @override
  final Color gradientGreen = Color(0xFF2E7D32);

  @override
  final Color gradientBlue = Color(0xFF1565C0);

  @override
  final Color gradientPurple = Color(0xFF6A1B9A);

  @override
  final Color gradientPink = Color(0xFFC2185B);

  @override
  final Color gradientIndigo = Color(0xFF283593);

  @override
  final Color gradientOrange = Color(0xFFD84315);

  @override
  final Color gradientBrown = Color(0xFF4E342E);

  @override
  final Color gradientBlueGrey = Color(0xFF455A64);

  @override
  final Color gradientTeal = Color(0xFF00695C);

  @override
  final Color answerCard = const Color.fromARGB(255, 41, 44, 50);

  // Dark mode theme colors
  @override
  final Color blueShadowColor = Color(0xFF1A4A5C);

  @override
  final Color blueTextColor = Color(0xFF84D6FD);

  @override
  final Color blueBackgroundColor = Color(0xFF0A1A2E);

  @override
  final Color redShadowColor = Color(0xFF4A1A1A);

  @override
  final Color redTextColor = Color(0xFFFF7575);

  @override
  final Color redBackgroundColor = Color(0xFF2E0A0A);

  @override
  final Color greenShadowColor = Color(0xFF1A4A1A);

  @override
  final Color greenTextColor = Color(0xFFA7EF75);

  @override
  final Color greenBackgroundColor = Color(0xFF0A2E0A);
}
