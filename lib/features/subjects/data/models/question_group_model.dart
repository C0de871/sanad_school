import '../../domain/entities/question_group_entity.dart';

class QuestionGroupModel extends QuestionGroupEntity {
  const QuestionGroupModel({
    required super.id,
    required super.name,
    required super.lessonId,
    required super.order,
  });

  factory QuestionGroupModel.fromMap(Map<String, dynamic> map) {
    return QuestionGroupModel(
      id: map['id'] as int,
      name: map['name'] as String,
      lessonId: map['lesson_id'] as int,
      order: map['order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lesson_id': lessonId,
      'order': order,
    };
  }
}
