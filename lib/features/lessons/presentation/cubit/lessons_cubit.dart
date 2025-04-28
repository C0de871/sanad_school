// lib/features/lessons/presentation/cubit/lessons_cubit.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/use_cases/get_lessons_usecase.dart';
import 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final GetLessonsUseCase getLessonsUseCase;

  LessonsCubit()
      : getLessonsUseCase = getIt(),
        super(LessonsInitial());

  Future<void> getLessons(int subjectId) async {
    emit(LessonsLoading());
    log("get lesson in lesson cubit");
    final Either<Failure, List<LessonEntity>> result = await getLessonsUseCase.call(LessonsParams(subjectId: subjectId));
    result.fold(
      (failure) => emit(LessonsError(failure.errMessage)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }
}
