// lib/features/lessons/presentation/cubit/lessons_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:sanad_school/features/lessons/domain/usecases/lessons_usecases.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/lesson_entity.dart';
import 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final GetLessonsUseCase getLessonsUseCase;
  final GetLessonsWithFavoriteGroupsUseCase getFavLessonsUseCase;
  final GetLessonsWithEditedQuestionsUseCase getEditedLessonsUseCase;
  final GetLessonsWithIncorrectAnswerGroupsUseCase getIncorrectLessonsUseCase;

  ScreenType screenType;

  LessonsCubit({required this.screenType})
      : getLessonsUseCase = getIt(),
        getEditedLessonsUseCase = getIt(),
        getFavLessonsUseCase = getIt(),
        getIncorrectLessonsUseCase = getIt(),
        super(LessonsInitial());

  Future<void> getRegularLessons(int subjectId,
      {bool isRefresh = false}) async {
    screenType = ScreenType.regularLessons;
    if (!isRefresh) {
      emit(LessonsLoading());
    }
    final Either<Failure, List<LessonEntity>> result =
        await getLessonsUseCase.call(LessonsParams(subjectId: subjectId));
    result.fold(
      (failure) => emit(LessonsError(failure.errMessage)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }

  Future<void> getFavLessons(int subjectId, {bool isRefresh = false}) async {
    screenType = ScreenType.favLessons;
    if (!isRefresh) {
      emit(LessonsLoading());
    }
    final Either<Failure, List<LessonEntity>> result =
        await getFavLessonsUseCase
            .call(LessonsWithFavoriteGroupsParams(subjectId: subjectId));
    result.fold(
      (failure) => emit(LessonsError(failure.errMessage)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }

  Future<void> getEditedLessons(int subjectId, {bool isRefresh = false}) async {
    screenType = ScreenType.editedLessons;
    if (!isRefresh) {
      emit(LessonsLoading());
    }
    final Either<Failure, List<LessonEntity>> result =
        await getEditedLessonsUseCase
            .call(LessonsWithEditedQuestionsParams(subjectId: subjectId));
    result.fold(
      (failure) => emit(LessonsError(failure.errMessage)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }

  Future<void> getIncorrectLessons(int subjectId, {bool isRefresh = false}) async {
    screenType = ScreenType.incorrectLessons;
    if (!isRefresh) {
      emit(LessonsLoading());
    }
    final Either<Failure, List<LessonEntity>> result =
        await getIncorrectLessonsUseCase
            .call(LessonsWithIncorrectAnswerGroupsParams(subjectId: subjectId));
    result.fold(
      (failure) => emit(LessonsError(failure.errMessage)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }
}
