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
  final int? typeId;

  QuestionsInLessonWithTypeParams({required this.lessonId, required this.typeId});
}

class QuestionsInSubjectByTag {
  final int tagId;

  QuestionsInSubjectByTag({required this.tagId});
}

class TagParams {
  final int subjectId;
  final bool isExam;

  TagParams({
    required this.subjectId,
    required this.isExam,
  });
}

class CodeBody {
  final String code;
  static const String codeKey = 'code';

  CodeBody({required this.code});

  Map<String, dynamic> toMap() {
    return {
      codeKey: code,
    };
  }
}
