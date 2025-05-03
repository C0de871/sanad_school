import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String uuid;
  final int? questionGroupId;
  final int? order;
  final int typeId;
  final List<Map<String, dynamic>> textQuestion;
  final String? questionPhoto;
  final List<List<dynamic>> choices;
  final int rightChoice;
  final int isEdited;
  final List<Map<String, dynamic>>? hint;
  final String? hintPhoto;

  const QuestionEntity({
    required this.id,
    required this.uuid,
    required this.questionGroupId,
    required this.order,
    required this.typeId,
    required this.textQuestion,
    this.questionPhoto,
    required this.choices,
    required this.rightChoice,
    required this.isEdited,
    this.hint,
    this.hintPhoto,
  });

  @override
  List<Object?> get props => [
        id,
        uuid,
        questionGroupId,
        order,
        typeId,
        textQuestion,
        questionPhoto,
        choices,
        rightChoice,
        isEdited,
        hint,
        hintPhoto,
      ];
}
