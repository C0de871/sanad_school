import 'package:equatable/equatable.dart';

import '../../presentation/questions_screen.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String uuid;
  final int lessonId;
  final int typeId;
  final int? previousQuestionId;
  final int? nextQuestionId;
  final List<Map<String, dynamic>> textQuestion;
  final String? questionPhoto;
  final List<List<Map<String, dynamic>>> choices;
  final int rightChoice;
  final int isEdited;
  final List<Map<String, dynamic>>? hint;
  final String? hintPhoto;
  final QuestionType type;

  const QuestionEntity({
    required this.id,
    required this.uuid,
    required this.lessonId,
    required this.typeId,
    required this.previousQuestionId,
    required this.nextQuestionId,
    required this.textQuestion,
    required this.questionPhoto,
    required this.choices,
    required this.rightChoice,
    required this.isEdited,
    required this.hint,
    required this.hintPhoto,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        uuid,
        lessonId,
        typeId,
        previousQuestionId,
        nextQuestionId,
        textQuestion,
        questionPhoto,
        choices,
        rightChoice,
        isEdited,
        hint,
        hintPhoto,
      ];
}
