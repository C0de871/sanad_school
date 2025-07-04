import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.link,
    required super.numberOfLessons,
    required super.numberOfTags,
    required super.numberOfExams,
    required super.numberOfQuestions,
    required super.isLocked,
    required super.teacher,
    required super.description,
    super.isSynced,
    super.lightColorCode,
    super.darkColorCode,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int,
      name: map['name'] as String,
      icon: map['icon'] as String,
      link: map['link'] as String,
      numberOfLessons: map['number_of_lessons'] as int,
      numberOfTags: map['number_of_tags'] as int,
      numberOfExams: map['number_of_exams'] as int,
      numberOfQuestions: map['number_of_questions'] as int,
      isLocked: map['is_locked'] ? 1 : 0,
      teacher: map['teacher'] as String,
      description: map['description'] as String,
      isSynced: map['is_synced'] as int?,
      lightColorCode: map['light_color_code'] as String?,
      darkColorCode: map['dark_color_code'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'link': link,
      'number_of_lessons': numberOfLessons,
      'number_of_tags': numberOfTags,
      'number_of_exams': numberOfExams,
      'number_of_questions': numberOfQuestions,
      'is_locked': isLocked,
      'teacher': teacher,
      'description': description,
      'is_synced': isSynced,
      'light_color_code': lightColorCode,
      'dark_color_code': darkColorCode,
    };
  }
}
