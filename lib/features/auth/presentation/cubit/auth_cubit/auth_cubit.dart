import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/core/utils/services/device_info_service.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';
import 'package:sanad_school/features/auth/domain/use_cases/get_token_use_case.dart';

import '../../../../../core/databases/api/auth_interceptor.dart';
import '../../../../../core/databases/params/body.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../../subject_type/domain/entities/type_entity.dart';
import '../../../../subject_type/domain/use_cases/get_types_use_case.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../../domain/use_cases/register_use_case.dart';
import '../../../domain/use_cases/logout_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GetTypesUseCase getTypesUseCase;
  final GetTokenUseCase getTokenUseCase;
  final LogoutUseCase logoutUseCase;
  final DeviceInfoService deviceInfoService;

  //! login controllers:
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  //! register personal info controllers:
  final registerFirstNameController = TextEditingController();
  final registerLastNameController = TextEditingController();
  final registerFatherNameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();

  //! register school info:
  final schoolInfoFormKey = GlobalKey<FormState>();
  final schoolNameController = TextEditingController();
  String selectedCity = "damascus";
  int selectedCertificateType = 1;
  

  AuthCubit()
      : registerUseCase = getIt(),
        loginUseCase = getIt(),
        getTypesUseCase = getIt(),
        getTokenUseCase = getIt(),
        logoutUseCase = getIt(),
        deviceInfoService = getIt(),
        super(AuthInitial()) {
    initAuthEventListener();
  }

  Future<void> register() async {
    emit(AuthLoading());
    final deviceId = await deviceInfoService.getDeviceId();
    final params = RegisterBody(
      firstName: registerFirstNameController.text,
      fatherName: registerFatherNameController.text,
      lastName: registerLastNameController.text,
      phone: registerPhoneController.text,
      city: selectedCity,
      email: registerEmailController.text,
      password: registerPasswordController.text,
      school: schoolNameController.text,
      typeId: selectedCertificateType.toString(),
      deviceId: deviceId,
    );
    final result = await registerUseCase(params);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (student) => emit(RegisterSuccess(student)),
    );
  }

  Future<void> emitLoginSuccess() async {
    if (state is! RegisterSuccess) return;
    emit(LoginSucess((state as RegisterSuccess).student));
  }

  Future<void> login() async {
    emit(AuthLoading());
    final deviceId = await deviceInfoService.getDeviceId();
    final params = LoginBody(
      email: loginEmailController.text,
      password: loginPasswordController.text,
      deviceId: deviceId,
    );
    final result = await loginUseCase(params);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (student) => emit(LoginSucess(student)),
    );
  }

  Future<void> fetchTypes() async {
    emit(AuthCertificateTypesLoading());
    final result = await getTypesUseCase.call();
    result.fold(
      (failure) =>
          emit(AuthCertificateTypesFailure(errMessage: failure.errMessage)),
      (types) => emit(AuthCertificateTypesLoaded(types: types)),
    );
  }

  // Listen to AuthEventBus events
  void initAuthEventListener() {
    AuthEventBus().stream.listen((event) {
      if (event == AuthEvent.accessTokenExpired) {
        logout();
      }
    });
  }

  Future<void> checkToken() async {
    // await logout();
    final token = await getTokenUseCase.call();
    log("----------------------");
    if (token != null) {
      log("user toke is $token");
      emit(PreviouslyAuthentecated());
    } else {
      emit(UnAuthentecated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (response) {
        emit(LogoutSuccess());
        // You can use response.message or response.status if needed
      },
    );
  }
}
