// lib/features/lessons/data/models/question_type_model.dart
import '../../domain/entities/question_type_entity.dart';

class QuestionTypeModel extends QuestionTypeEntity {
  static const String idKey = 'id';
  static const String nameKey = 'name';

  const QuestionTypeModel({
    super.id,
    required super.name,
  });

  factory QuestionTypeModel.fromMap(Map<String, dynamic> map) {
    return QuestionTypeModel(
      id: map[idKey],
      name: map[nameKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
    };
  }
}
