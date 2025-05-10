import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/use_cases/get_subjects_use_case.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final GetSubjectsUseCase getSubjectsUseCase;

  SubjectCubit()
      : getSubjectsUseCase = getIt(),
        super(SubjectInitial());

  Future<void> getSubjects({bool isRefresh = false}) async {
    emit(SubjectLoading());
    final result = await getSubjectsUseCase(isRefresh: isRefresh);
    result.fold(
      (failure) => emit(SubjectFailure(failure.errMessage)),
      (subjects) => emit(SubjectSuccess(subjects)),
    );
  }

  @override
  Future<void> close() {
    log("subject cubit is closed");
    return super.close();
  }

  
}
