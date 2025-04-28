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

  Future<void> getSubjects() async {
    emit(SubjectLoading());
    final result = await getSubjectsUseCase();
    result.fold(
      (failure) => emit(SubjectFailure(failure.errMessage)),
      (subjects) => emit(SubjectSuccess(subjects)),
    );
  }
}
