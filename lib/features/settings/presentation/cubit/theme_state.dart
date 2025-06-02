// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.themeStatus = ThemeStatus.initial,
  });

  final ThemeMode themeMode;
  final ThemeStatus themeStatus;

  @override
  List<Object> get props => [themeMode, themeStatus];

  ThemeState copyWith({ThemeMode? themeMode, ThemeStatus? themeStatus}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      themeStatus: themeStatus ?? this.themeStatus,
    );
  }
}

enum ThemeStatus {
  initial,
  loading,
  loaded,
  error,
}

extension ThemeStatusX on ThemeStatus {
  bool get isInitial => this == ThemeStatus.initial;
  bool get isLoading => this == ThemeStatus.loading;
  bool get isLoaded => this == ThemeStatus.loaded;
  bool get isError => this == ThemeStatus.error;
}
