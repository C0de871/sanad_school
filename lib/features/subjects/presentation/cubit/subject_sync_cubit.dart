import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sanad_school/core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../lessons/domain/entities/lesson_entity.dart';
import '../../../lessons/domain/use_cases/get_lessons_usecase.dart';
import '../../domain/entities/subject_sync_entity.dart';
import '../../domain/use_cases/get_subject_sync_use_case.dart';

part 'subject_sync_state.dart';

class SubjectSyncCubit extends Cubit<SubjectSyncState> {
  final GetSubjectSyncUseCase getSubjectSyncUseCase;
  final GetLessonsUseCase getLessonsUseCase;

  SubjectSyncCubit()
      : getSubjectSyncUseCase = getIt(),
        getLessonsUseCase = getIt(),
        super(SubjectSyncInitial());

  Future<void> getSubjectSync(int subjectId) async {
    emit(SubjectSyncLoading());
    final result = await getLessonsUseCase.call(LessonsParams(subjectId: subjectId));
    result.fold(
      (failure) async {
        emit(SubjectSyncFailure(failure.errMessage));
      },
      (lessons) async {
        if (lessons.isEmpty) {
          final sync = await getSubjectSyncUseCase.call(subjectId);
          sync.fold((left) {
            emit(SubjectSyncFailure(left.errMessage));
          }, (syncSubject) async {
            final lessonsResponse = await getLessonsUseCase.call(LessonsParams(subjectId: subjectId));
            lessonsResponse.fold((failure) {
              emit(SubjectSyncFailure(failure.errMessage));
            }, (lessons) {
              emit(SubjectSyncSucessAndFetchLessonsSuccess(syncSubject, lessons: lessons, message: "message"));
            });
          });
        } else {
          emit(SubjectSyncFailedAndFetchLessonsSuccess(lessons: lessons, message: "message"));
        }
        // emit(SubjectSyncLoading());
        // final response = await getLessonsUseCase.call(LessonsParams(subjectId: subjectId));
        // response.fold((failure) {
        //   emit(SubjectSyncFailure(failure.errMessage));
        // }, (lessons) {
        //   emit(SubjectSyncSucessAndFetchLessonsSuccess(subjectSync, lessons: lessons, message: ""));
        // });
      },
    );
  }
}
