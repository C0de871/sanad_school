import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String iconKey = 'icon';
  static const String linkKey = 'link';
  static const String teacherKey = 'teacher';
  static const String descriptionKey = 'description';

  const SubjectModel({
    required super.id,
    required super.name,
    required super.iconCodePoint,
    required super.link,
    required super.teacher,
    required super.description,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map[idKey],
      name: map[nameKey],
      iconCodePoint: map[iconKey],
      link: map[linkKey],
      teacher: map[teacherKey],
      description: map[descriptionKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
      iconKey: iconCodePoint,
      linkKey: link,
      teacherKey: teacher,
      descriptionKey: description,
    };
  }
}
