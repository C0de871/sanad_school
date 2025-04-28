// lib/features/lessons/domain/usecases/get_lessons_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';
import '../repo/lessons_repository.dart';

class GetLessonsUseCase {
  final LessonsRepository repository;

  GetLessonsUseCase({required this.repository});

  Future<Either<Failure, List<LessonEntity>>> call(LessonsParams params) async {
    return await repository.getLessons(params);
  }
}
