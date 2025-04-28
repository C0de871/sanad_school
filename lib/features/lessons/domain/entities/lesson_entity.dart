// lib/features/lessons/domain/entities/lesson_entity.dart
import 'package:equatable/equatable.dart';
import 'package:sanad_school/features/lessons/domain/entities/lesson_with_one_type_entity.dart';
import 'question_type_entity.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final int subjectId;
  final List<QuestionTypeEntity> questionTypes;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.questionTypes,
  });

  LessonWithOneTypeEntity toLessonWithOneTypeEntity(int questiontypeId) {
    return LessonWithOneTypeEntity(
      id: id,
      title: title,
      subjectId: subjectId,
      questionType: questionTypes[questiontypeId],
    );
  }

  @override
  List<Object?> get props => [id, title, subjectId, questionTypes];
}
