import 'dart:ui';

class QuestionFromQuizArg {
  final int subjectId;
  final List<int> lessonIds;
  final List<int> tagIds;
  final List<int> typeIds;
  final int questionCount;
  final TextDirection textDirection;
  final Color subjectColor;

  QuestionFromQuizArg({
    required this.subjectId,
    required this.lessonIds,
    required this.tagIds,
    required this.typeIds,
    required this.questionCount,
    required this.textDirection,
    required this.subjectColor,
  });
}
