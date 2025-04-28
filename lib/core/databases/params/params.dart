abstract class Params {}

class NoParams extends Params {}

class NoBody {}

class TemplateTParams extends Params {}

// lib/features/lessons/data/params/lessons_params.dart
class LessonsParams {
  final int subjectId;

  LessonsParams({required this.subjectId});
}

class QuestionsInLessonWithTypeParams {
  final int lessonId;
  final int typeId;

  QuestionsInLessonWithTypeParams({required this.lessonId, required this.typeId});
}
