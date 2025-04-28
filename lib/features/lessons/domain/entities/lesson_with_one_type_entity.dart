// lib/features/lessons/domain/entities/lesson_entity.dart
import 'package:equatable/equatable.dart';
import 'question_type_entity.dart';

class LessonWithOneTypeEntity extends Equatable {
  final int id;
  final String title;
  final int subjectId;
  final QuestionTypeEntity questionType;

  const LessonWithOneTypeEntity({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.questionType,
  });

  @override
  List<Object?> get props => [id, title, subjectId, questionType];
}
