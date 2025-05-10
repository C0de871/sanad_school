import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../lessons/domain/usecases/get_lessons_usecase.dart';
import '../../domain/use_cases/get_subject_sync_use_case.dart';

part 'subject_sync_state.dart';

class SubjectSyncCubit extends Cubit<SubjectSyncState> {
  final GetSubjectSyncUseCase getSubjectSyncUseCase;
  final GetLessonsUseCase getLessonsUseCase;

  SubjectSyncCubit()
      : getSubjectSyncUseCase = getIt(),
        getLessonsUseCase = getIt(),
        super(SubjectSyncInitial());

  Future<void> getSubjectSync(int subjectId, {bool isRefresh = false}) async {
    emit(SubjectSyncLoading());
    final result = await getSubjectSyncUseCase.call(subjectId, isRefresh: isRefresh);
    result.fold((failure) {
      emit(SubjectSyncFailure(failure.errMessage));
    }, (isSynced) {
      emit(SubjectSyncSuccess(isSynced));
    });
  }
}
