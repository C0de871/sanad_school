import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/question_type_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.subjectId,
    required super.questionTypes,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] as int,
      title: map['title'] as String,
      subjectId: map['subject_id'] as int,
      questionTypes: List<Map<String, dynamic>>.from(map['question_types'])
          .map((type) => QuestionTypeEntity(
                id: type['id'] as int,
                name: type['name'] as String,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject_id': subjectId,
      'question_types': questionTypes
          .map((type) => {
                'id': type.id,
                'name': type.name,
              })
          .toList(),
    };
  }
} 