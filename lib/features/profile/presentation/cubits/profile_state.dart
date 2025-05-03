part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  final bool isEditing;

  const ProfileLoading({this.isEditing = false});

  @override
  List<Object> get props => [isEditing];
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class LogoutSuccess extends ProfileState {}

class FailedToLogout extends ProfileLoaded {
  final String errMessage;
  const FailedToLogout(super.profile, this.errMessage);
  
}

class ProfileEditing extends ProfileLoaded {
  // final ProfileEntity updatedProfile;

  const ProfileEditing(super.updatedProfile);

  @override
  List<Object> get props => [...super.props];
}

class ProfileUpdated extends ProfileLoaded {
  // final ProfileEntity profile;

  const ProfileUpdated(super.profile);

  @override
  List<Object> get props => [...super.props];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ThemeModeChanged extends ProfileLoaded {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode, super.profile);

  ThemeModeChanged copyWith({
    ThemeMode? themeMode,
    ProfileEntity? profile,
  }) {
    return ThemeModeChanged(
      themeMode ?? this.themeMode,
      profile ?? super.profile,
    );
  }

  @override
  List<Object> get props => [themeMode, ...super.props];
}
