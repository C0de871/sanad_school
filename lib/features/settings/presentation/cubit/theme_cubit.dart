import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/features/settings/domain/usecases/change_theme.dart';
import 'package:sanad_school/features/settings/domain/usecases/get_theme.dart';

import '../../../../core/utils/services/service_locator.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  final ChangeThemeUsecase _changeThemeUsecase = getIt();
  final GetThemeUsecase _getThemeUsecase = getIt();

  changeTheme(ThemeMode themeMode) async {
    emit(state.copyWith(themeStatus: ThemeStatus.loading));
    final themeResponse = await _changeThemeUsecase.call(mode: themeMode);
    emit(state.copyWith(themeStatus: ThemeStatus.loaded, themeMode: themeMode));
  }

  getTheme() async {
    emit(state.copyWith(themeStatus: ThemeStatus.loading));
    final themeResponse = await _getThemeUsecase.call();
    themeResponse.fold((error) {
      //todo
    }, (theme) {
      emit(state.copyWith(themeMode: theme, themeStatus: ThemeStatus.loaded));
    });
  }
}
