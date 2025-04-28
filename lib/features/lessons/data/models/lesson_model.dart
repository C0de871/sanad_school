// lib/features/lessons/data/models/lesson_model.dart
import '../../domain/entities/lesson_entity.dart';
import 'question_type_model.dart';

class LessonModel extends LessonEntity {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String subjectIdKey = 'subject_id';
  static const String questionTypesKey = 'question_types';

  const LessonModel({
    required super.id,
    required super.title,
    required super.subjectId,
    required List<QuestionTypeModel> super.questionTypes,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map[idKey],
      title: map[titleKey],
      subjectId: map[subjectIdKey],
      questionTypes: map[questionTypesKey] != null
          ? List<QuestionTypeModel>.from(
              (map[questionTypesKey] as List).map(
                (e) => QuestionTypeModel.fromMap(e),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      titleKey: title,
      subjectIdKey: subjectId,
      questionTypesKey: questionTypes.map((e) => (e as QuestionTypeModel).toMap()).toList(),
    };
  }
}
