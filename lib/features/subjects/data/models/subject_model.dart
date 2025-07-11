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

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String iconKey = 'icon';
  static const String linkKey = 'link';
  static const String numberOfLessonsKey = 'number_of_lessons';
  static const String numberOfTagsKey = 'number_of_tags';
  static const String numberOfExamsKey = 'number_of_exams';
  static const String numberOfQuestionsKey = 'number_of_questions';
  static const String isLockedKey = 'is_locked';
  static const String teacherKey = 'teacher';
  static const String descriptionKey = 'description';
  static const String isSyncedKey = 'is_synced';
  static const String lightColorCodeKey = 'light_color_code';
  static const String darkColorCodeKey = 'dark_color_code';

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map[idKey] as int,
      name: map[nameKey] as String,
      icon: map[iconKey] as String,
      link: map[linkKey] as String,
      numberOfLessons: map[numberOfLessonsKey] as int,
      numberOfTags: map[numberOfTagsKey] as int,
      numberOfExams: map[numberOfExamsKey] as int,
      numberOfQuestions: map[numberOfQuestionsKey] as int,
      isLocked: map[isLockedKey] ? 1 : 0,
      teacher: map[teacherKey] as String,
      description: map[descriptionKey] as String,
      isSynced: map[isSyncedKey] as int?,
      lightColorCode: map[lightColorCodeKey] as String?,
      darkColorCode: map[darkColorCodeKey] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
      iconKey: icon,
      linkKey: link,
      numberOfLessonsKey: numberOfLessons,
      numberOfTagsKey: numberOfTags,
      numberOfExamsKey: numberOfExams,
      numberOfQuestionsKey: numberOfQuestions,
      isLockedKey: isLocked,
      teacherKey: teacher,
      descriptionKey: description,
      isSyncedKey: isSynced,
      lightColorCodeKey: lightColorCode,
      darkColorCodeKey: darkColorCode,
    };
  }
}
