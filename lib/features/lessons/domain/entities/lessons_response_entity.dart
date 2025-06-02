import 'package:sanad_school/features/lessons/domain/entities/lesson_entity.dart';

class LessonsResponseEntity {
  final List<LessonEntity> lessons;
  final String message;
  final int status;
  final int totalQuestions;
  final int totalAnsweredQuestions;

  LessonsResponseEntity(
      {required this.lessons,
      required this.message,
      required this.status,
      this.totalQuestions = 0,
      this.totalAnsweredQuestions = 1});
}
