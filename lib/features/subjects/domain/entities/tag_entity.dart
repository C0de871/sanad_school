import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final int id;
  final String title;
  final int subjectId;
  final int isExam;

  const TagEntity({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.isExam,
  });

  @override
  List<Object?> get props => [id, title, subjectId, isExam];
}
