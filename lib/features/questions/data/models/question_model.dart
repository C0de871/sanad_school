import 'dart:developer';
import 'dart:typed_data';

import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  static const String idKey = 'id';
  static const String uuidKey = 'uuid';
  static const String questionGroupIdKey = 'question_group_id';
  static const String displayOrderKey = 'display_order';
  static const String typeIdKey = 'type_id';
  static const String textQuestionKey = 'text_question';
  static const String questionPhotoKey = 'question_photo';
  static const String choicesKey = 'choices';
  static const String rightChoiceKey = 'right_choice';
  static const String isEditedKey = 'is_edited';
  static const String hintKey = 'hint';
  static const String hintPhotoKey = 'hint_photo';
  static const String opsKey = 'ops';
  static const String isFavoriteKey = 'is_favorite';
  static const String answerStatusKey = 'answer_status';
  static const String noteKey = 'note';
  static const String downloadedHintPhotoKey = 'downloaded_hint_photo';
  static const String downloadedQuestionPhotoKey = 'downloaded_question_photo';
  static const String isAnsweredKey = 'is_answered';
  static const String isCorrectedKey = 'is_corrected';
  static const String isAnsweredCorrectlyKey = 'is_answered_correctly';
  static const String userAnswerKey = 'user_answer';

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
    super.isFavorite,
    super.answerStatus,
    super.note,
    super.downloadedHintPhoto,
    super.downloadedQuestionPhoto,
    super.isAnswered,
    super.isCorrected,
    super.isAnsweredCorrectly,
    super.userAnswer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map[idKey] as int,
      uuid: map[uuidKey] as String,
      questionGroupId: map[questionGroupIdKey] as int?,
      order: map[displayOrderKey] as int?,
      typeId: map[typeIdKey] as int,
      textQuestion:
          List<Map<String, dynamic>>.from(map[textQuestionKey][opsKey]),
      questionPhoto: map[questionPhotoKey] as String?,
      choices: List<List<dynamic>>.from(
        (map[choicesKey] as List).map((choice) => choice[opsKey]),
      ),
      rightChoice: map[rightChoiceKey] as int,
      isEdited: map[isEditedKey] as int == 1,
      hint: (map[hintKey] != null && map[hintKey][opsKey] != null)
          ? List<Map<String, dynamic>>.from(map[hintKey][opsKey])
          : null,
      hintPhoto: map[hintPhotoKey] as String?,
      isFavorite: map[isFavoriteKey] as bool? ?? false,
      answerStatus: map[answerStatusKey] as bool? ?? false,
      note: map[noteKey] as String?,
      downloadedHintPhoto: map[downloadedHintPhotoKey] as Uint8List?,
      downloadedQuestionPhoto: map[downloadedQuestionPhotoKey] as Uint8List?,
      isAnswered: map[isAnsweredKey] as bool? ?? false,
      isCorrected: map[isCorrectedKey] as bool? ?? false,
      isAnsweredCorrectly: map[isAnsweredCorrectlyKey] as bool? ?? false,
      userAnswer: map[userAnswerKey] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      uuidKey: uuid,
      questionGroupIdKey: questionGroupId,
      displayOrderKey: order,
      typeIdKey: typeId,
      textQuestionKey: {opsKey: textQuestion},
      questionPhotoKey: questionPhoto,
      choicesKey: choices.map((choice) => {opsKey: choice}).toList(),
      rightChoiceKey: rightChoice,
      isEditedKey: isEdited,
      hintKey: hint != null ? {opsKey: hint} : null,
      hintPhotoKey: hintPhoto,
      isFavoriteKey: isFavorite ? 1 : 0,
      answerStatusKey: answerStatus ? 1 : 0,
      noteKey: note,
      downloadedHintPhotoKey: downloadedHintPhoto,
      downloadedQuestionPhotoKey: downloadedQuestionPhoto,
      isAnsweredKey: isAnswered ? 1 : 0,
      isCorrectedKey: isCorrected ? 1 : 0,
      isAnsweredCorrectlyKey: isAnsweredCorrectly ? 1 : 0,
      userAnswerKey: userAnswer,
    };
  }
}
