import 'dart:developer';

import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  static const String idKey = 'id';
  static const String uuidKey = 'uuid';
  static const String questionGroupIdKey = 'question_group_id';
  static const String orderKey = 'order';
  static const String typeIdKey = 'type_id';
  static const String textQuestionKey = 'text_question';
  static const String questionPhotoKey = 'question_photo';
  static const String choicesKey = 'choices';
  static const String rightChoiceKey = 'right_choice';
  static const String isEditedKey = 'is_edited';
  static const String hintKey = 'hint';
  static const String hintPhotoKey = 'hint_photo';
  static const String opsKey = 'ops';

  const QuestionModel({
    required super.id,
    required super.uuid,
    super.questionGroupId,
    super.order,
    required super.typeId,
    required super.textQuestion,
    super.questionPhoto,
    required super.choices,
    required super.rightChoice,
    required super.isEdited,
    super.hint,
    super.hintPhoto,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    // log("question model map: $map");
    return QuestionModel(
      id: map[idKey] as int,
      uuid: map[uuidKey] as String,
      questionGroupId: map[questionGroupIdKey] as int?,
      order: map[orderKey] as int?,
      typeId: map[typeIdKey] as int,
      textQuestion: List<Map<String, dynamic>>.from(map[textQuestionKey][opsKey]),
      questionPhoto: map[questionPhotoKey] as String?,
      choices: List<List<dynamic>>.from(
        (map[choicesKey] as List).map((choice) => choice[opsKey]),
      ),
      rightChoice: map[rightChoiceKey] as int,
      isEdited: map[isEditedKey] as int,
      hint: map[hintKey] != null ? List<Map<String, dynamic>>.from(map[hintKey][opsKey]) : null,
      hintPhoto: map[hintPhotoKey] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      uuidKey: uuid,
      questionGroupIdKey: questionGroupId,
      orderKey: order,
      typeIdKey: typeId,
      textQuestionKey: {opsKey: textQuestion},
      questionPhotoKey: questionPhoto,
      choicesKey: choices.map((choice) => {opsKey: choice}).toList(),
      rightChoiceKey: rightChoice,
      isEditedKey: isEdited,
      hintKey: hint != null ? {opsKey: hint} : null,
      hintPhotoKey: hintPhoto,
    };
  }
}
