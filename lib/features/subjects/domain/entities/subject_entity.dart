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
  final int isLocked;
  final String teacher;
  final String description;
  final String? lightColorCode;
  final String? darkColorCode;
  final int? isSynced;

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
    this.lightColorCode,
    this.darkColorCode,
    this.isSynced,
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
    lightColorCode,
    darkColorCode,
    isSynced,
  ];
}
