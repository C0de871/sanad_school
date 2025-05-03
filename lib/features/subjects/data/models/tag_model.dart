import '../../domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  const TagModel({
    required super.id,
    required super.title,
    required super.subjectId,
    required super.isExam,
  });

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] as int,
      title: map['name'] as String,
      subjectId: map['subject_id'] as int,
      isExam: map['is_exam'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject_id': subjectId,
      "is_exam": isExam,
    };
  }
}
