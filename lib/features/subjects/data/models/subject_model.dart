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
      isLocked: map['is_locked'] == 1,
      teacher: map['teacher'] as String,
      description: map['description'] as String,
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
      'is_locked': isLocked ? 1 : 0,
      'teacher': teacher,
      'description': description,
    };
  }
}
