import 'package:equatable/equatable.dart';

class QuestionGroupEntity extends Equatable {
  final int id;
  final String name;
  final int lessonId;
  final int order;

  const QuestionGroupEntity({
    required this.id,
    required this.name,
    required this.lessonId,
    required this.order,
  });

  @override
  List<Object?> get props => [id, name, lessonId, order];
}
