import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/subject_sync_entity.dart';
import '../../domain/use_cases/get_subject_sync_use_case.dart';

part 'subject_sync_state.dart';

class SubjectSyncCubit extends Cubit<SubjectSyncState> {
  final GetSubjectSyncUseCase getSubjectSyncUseCase;

  SubjectSyncCubit()
      : getSubjectSyncUseCase = getIt(),
        super(SubjectSyncInitial());

  Future<void> getSubjectSync(int subjectId) async {
    emit(SubjectSyncLoading());
    final result = await getSubjectSyncUseCase.call(subjectId);
    result.fold(
      (failure) => emit(SubjectSyncFailure(failure.errMessage)),
      (subjectSync) => emit(SubjectSyncSuccess(subjectSync)),
    );
  }
}
