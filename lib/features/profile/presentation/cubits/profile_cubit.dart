import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/use_cases/get_student_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetStudentProfileUseCase getStudentProfile;
  final LogoutUseCase logoutUseCase;
  // final UpdateStudentProfileUseCase? updateStudentProfile; // Optional for future implementation

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final schoolNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();


  // Form values
  String selectedCertificate = '';
  String selectedCity = 'damascus';
  ThemeMode currentThemeMode = ThemeMode.light;

  // State tracking
  bool _hasUnsavedChanges = false;
  ProfileEntity? _originalProfile;

  bool get hasUnsavedChanges => _hasUnsavedChanges;

  ProfileCubit()
      : getStudentProfile = getIt(),
        logoutUseCase = getIt(),
        super(ProfileInitial()) {
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    void listener() {
      _hasUnsavedChanges = true;
    }

    firstNameController.addListener(listener);
    lastNameController.addListener(listener);
    fatherNameController.addListener(listener);
    schoolNameController.addListener(listener);
    emailController.addListener(listener);
    phoneController.addListener(listener);
  }

  void updateCertificateType(String? value) {
    //todo
    // if (value != null && value != selectedCertificate) {
    //   selectedCertificate = value;
    //   _hasUnsavedChanges = true;
    //   emit(ProfileEditing(_getCurrentProfileFromForm()));
    // }
  }

  void updateCity(String? value) {
    if (value != null && value != selectedCity) {
      selectedCity = value;
      _hasUnsavedChanges = true;
      emit(ProfileEditing(_getCurrentProfileFromForm()));
    }
  }

  void updateThemeMode(ThemeMode mode) {
    if (state is ProfileLoaded) {
      if (mode != currentThemeMode) {
        currentThemeMode = mode;
        emit(ThemeModeChanged(
          mode,
          (state as ProfileLoaded).profile,
        ));
      }
    }
  }

  Future<void> fetchStudentProfile() async {
    emit(ProfileLoading());
    final either = await getStudentProfile();
    either.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (profile) {
        _originalProfile = profile;
        _populateFormWithProfile(profile);
        emit(ProfileLoaded(profile));
      },
    );
  }

  void _populateFormWithProfile(ProfileEntity profile) {
    // Populate controllers with profile data
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    fatherNameController.text = profile.fatherName;
    schoolNameController.text = profile.school;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    // passwordController.text = profile.;

    // Set dropdown values
    selectedCertificate = profile.type;
    selectedCity = profile.city;

    // Reset unsaved changes flag
    _hasUnsavedChanges = false;
  }

  ProfileEntity _getCurrentProfileFromForm() {
    return ProfileEntity(
        id: _originalProfile?.id ?? 0,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        fatherName: fatherNameController.text,
        school: schoolNameController.text,
        email: emailController.text,
        type: selectedCertificate,
        city: selectedCity,
        phone: phoneController.text, //todo
        deviceId: "" //todo
        );
  }

  // Future<void> saveChanges() async {
  //   if (!_hasUnsavedChanges) return;

  //   emit(ProfileLoading(isEditing: true));

  //   final profile = _getCurrentProfileFromForm();

  //   // For future implementation when the update use case is available
  //   if (updateStudentProfile != null) {
  //     final either = await updateStudentProfile!(profile);
  //     either.fold(
  //       (failure) => emit(ProfileError(failure.errMessage)),
  //       (_) {
  //         _originalProfile = profile;
  //         _hasUnsavedChanges = false;
  //         emit(ProfileUpdated(profile));
  //       },
  //     );
  //   } else {
  //     // Simulate successful update for now
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     _originalProfile = profile;
  //     _hasUnsavedChanges = false;
  //     emit(ProfileUpdated(profile));
  //   }
  // }

  Future<void> logout() async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(ProfileLoading());
      final result = await logoutUseCase.call();
      result.fold(
        (failure) => emit(FailedToLogout(
          currentState.profile,
          failure.errMessage,
        )),
        (response) {
          emit(LogoutSuccess());
        },
      );
    }
  }

  void discardChanges() {
    if (_originalProfile != null) {
      _populateFormWithProfile(_originalProfile!);
      emit(ProfileLoaded(_originalProfile!));
    }
  }

  @override
  Future<void> close() {
    // Dispose all controllers
    firstNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    schoolNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
