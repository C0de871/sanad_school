import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String link;
  final int numberOfLessons;
  final int numberOfTags;
  final int numberOfExams;
  final int numberOfQuestions;
  final bool isLocked;
  final String teacher;
  final String description;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.link,
    required this.numberOfLessons,
    required this.numberOfTags,
    required this.numberOfExams,
    required this.numberOfQuestions,
    required this.isLocked,
    required this.teacher,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        link,
        numberOfLessons,
        numberOfTags,
        numberOfExams,
        numberOfQuestions,
        isLocked,
        teacher,
        description,
      ];
}
