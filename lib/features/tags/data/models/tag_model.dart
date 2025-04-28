// lib/features/subject/data/models/tag_model.dart
import '../../domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String subjectIdKey = 'subject_id';
  static const String isExamKey = 'is_exam';

  const TagModel({
    required super.id,
    required super.name,
    required super.subjectId,
    required super.isExam,
  });

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map[idKey],
      name: map[nameKey],
      subjectId: map[subjectIdKey],
      isExam: map[isExamKey] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
      subjectIdKey: subjectId,
      isExamKey: isExam ? 1 : 0,
    };
  }
}
