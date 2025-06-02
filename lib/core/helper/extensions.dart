import 'package:flutter/material.dart';

import '../utils/constants/constant.dart';

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

// Extension to capitalize strings
extension StringCapitalize on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// extension ThemeModeToString on ThemeMode {
//   String themeModeToString() {
//     switch (this) {
//       case ThemeMode.system:
//         return Constant.systemDefault;
//       case ThemeMode.light:
//         return Constant.lightMode;
//       case ThemeMode.dark:
//         return Constant.darkMode;
//     }
//   }
// }
