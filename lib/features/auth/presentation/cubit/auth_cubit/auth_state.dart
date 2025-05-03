part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class PreviouslyAuthentecated extends AuthState {}

class UnAuthentecated extends AuthState {}

class LoginSucess extends AuthState {
  final StudentEntity student;

  const LoginSucess(this.student);

  @override
  List<Object> get props => [student];
}

class RegisterSuccess extends AuthState {
  final StudentEntity student;

  const RegisterSuccess(this.student);

  @override
  List<Object> get props => [student];
}

class AuthCertificateTypesLoading extends AuthState {}

class AuthCertificateTypesFailure extends AuthState {
  final String errMessage;

  const AuthCertificateTypesFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}

class AuthCertificateTypesLoaded extends AuthState {
  final List<TypeEntity> types;

  const AuthCertificateTypesLoaded({required this.types});

  @override
  List<Object> get props => [types];
}

class AuthFailure extends AuthState {
  final String errMessage;

  const AuthFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}

class LogoutSuccess extends AuthState {}
