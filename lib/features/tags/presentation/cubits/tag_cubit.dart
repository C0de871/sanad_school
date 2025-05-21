// lib/features/subject/presentation/cubit/tag_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/use_cases/get_tags_or_exams.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final GetTagsOrExamsUseCase getTagsOrExams;

  TagCubit()
      : getTagsOrExams = getIt(),
        super(TagInitial());

  Future<void> fetchTagsOrExams({required int subjectId, required bool isExam, bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(TagLoading());
    }

    final params = TagParams(subjectId: subjectId, isExam: isExam);
    final Either<Failure, List<TagEntity>> result = await getTagsOrExams(params);

    result.fold(
      (failure) => emit(TagError(message: failure.errMessage)),
      (tags) => emit(TagLoaded(tags: tags)),
    );
  }
}
