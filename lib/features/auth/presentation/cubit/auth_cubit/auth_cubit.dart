import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';

import '../../../../../core/databases/params/body.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../../subject_type/domain/entities/type_entity.dart';
import '../../../../subject_type/domain/use_cases/get_types_use_case.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../../domain/use_cases/register_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GetTypesUseCase getTypesUseCase;

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
  final Map<String, String> syrianCitiesMap = {
    'damascus': 'دمشق',
    'aleppo': 'حلب',
    'homs': 'حمص',
    'hama': 'حماة',
    'latakia': 'اللاذقية',
    'tartus': 'طرطوس',
    'deir_ezzor': 'دير الزور',
    'raqqa': 'الرقة',
    'hasaka': 'الحسكة',
    'qamishli': 'القامشلي',
  };

  AuthCubit()
      : registerUseCase = getIt(),
        loginUseCase = getIt(),
        getTypesUseCase = getIt(),
        super(AuthInitial());

  Future<void> register() async {
    if (state is! AuthCertificateTypesLoaded) return;
    RegisterBody params = RegisterBody(
      firstName: registerFirstNameController.text,
      fatherName: registerFatherNameController.text,
      lastName: registerLastNameController.text,
      phone: registerPhoneController.text,
      email: registerEmailController.text,
      city: selectedCity,
      password: registerPasswordController.text,
      school: schoolNameController.text,
      typeId: selectedCertificateType.toString(),
    );
    emit(AuthLoading());
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
    final params = LoginBody(
      email: loginEmailController.text,
      password: loginPasswordController.text,
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
      (failure) => emit(AuthCertificateTypesFailure(errMessage: failure.errMessage)),
      (types) => emit(AuthCertificateTypesLoaded(types: types)),
    );
  }
}
