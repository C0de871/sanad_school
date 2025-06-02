import 'package:flutter/material.dart';
import 'package:sanad_school/core/databases/cache/storage_helper.dart';

import '../../../../core/helper/theme_mode_helper.dart';

class ThemeLocaDataSource {
  final StorageHelper storageHelper;

  static final tokenKey = 'theme';

  ThemeLocaDataSource({required this.storageHelper});

  Future<void> changeTheme(ThemeMode themeMode) async {
    await storageHelper.saveData(
        key: tokenKey, value: ThemeModeHelper.themeModeToString(themeMode));
  }

  Future<ThemeMode> getTheme() async {
    final themeModeString = await storageHelper.getData(key: tokenKey);
    return ThemeModeHelper.stringToThemeMode(themeModeString);
  }
}
