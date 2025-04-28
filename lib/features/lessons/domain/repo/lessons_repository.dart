// lib/features/lessons/domain/repositories/lessons_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';

abstract class LessonsRepository {
  Future<Either<Failure, List<LessonEntity>>> getLessons(LessonsParams params);
}
