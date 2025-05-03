import 'package:equatable/equatable.dart';

class QuestionTagEntity extends Equatable {
  final int questionId;
  final int tagId;

  const QuestionTagEntity({
    required this.questionId,
    required this.tagId,
  });

  @override
  List<Object?> get props => [questionId, tagId];
}
