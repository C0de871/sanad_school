import 'package:equatable/equatable.dart';
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

  @override
  List<Object?> get props => [id, title, subjectId, questionTypes];
}
