import 'package:flutter/material.dart';

import '../utils/constants/constant.dart';

class ThemeModeHelper {
  static ThemeMode stringToThemeMode(String? themeModeString) {
    switch (themeModeString) {
      case Constant.lightMode:
        return ThemeMode.light;
      case Constant.darkMode:
        return ThemeMode.dark;
      case Constant.systemDefault:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Constant.lightMode;
      case ThemeMode.dark:
        return Constant.darkMode;

      case ThemeMode.system:
        return Constant.systemDefault;
      default:
        return Constant.systemDefault;
    }
  }
}
