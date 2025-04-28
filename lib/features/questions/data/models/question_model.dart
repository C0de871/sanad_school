import '../../domain/entities/question_entity.dart';
import '../../presentation/questions_screen.dart';

class QuestionModel extends QuestionEntity {
  static const String idKey = 'id';
  static const String uuidKey = 'uuid';
  static const String lessonIdKey = 'lesson_id';
  static const String typeIdKey = 'type_id';
  static const String previousQuestionIdKey = 'previous_question_id';
  static const String nextQuestionIdKey = 'next_question_id';
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
    required super.lessonId,
    required super.typeId,
    required super.previousQuestionId,
    required super.nextQuestionId,
    required super.textQuestion,
    required super.questionPhoto,
    required super.choices,
    required super.rightChoice,
    required super.isEdited,
    required super.hint,
    required super.hintPhoto,
  }) : super(type: typeId <= 1 ? QuestionType.multipleChoice : QuestionType.written);

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map[idKey],
      uuid: map[uuidKey],
      lessonId: map[lessonIdKey],
      typeId: map[typeIdKey],
      previousQuestionId: map[previousQuestionIdKey],
      nextQuestionId: map[nextQuestionIdKey],
      textQuestion: List<Map<String, dynamic>>.from(map[textQuestionKey][opsKey]),
      questionPhoto: map[questionPhotoKey],
      choices: List<List<Map<String, dynamic>>>.from(
        (map[choicesKey] as List).map(
          (choice) => List<Map<String, dynamic>>.from(choice[opsKey]),
        ),
      ),
      rightChoice: map[rightChoiceKey],
      isEdited: map[isEditedKey],
      hint: map[hintKey] == null ? [] : List<Map<String, dynamic>>.from(map[hintKey][opsKey]),
      hintPhoto: map[hintPhotoKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      uuidKey: uuid,
      lessonIdKey: lessonId,
      typeIdKey: typeId,
      previousQuestionIdKey: previousQuestionId,
      nextQuestionIdKey: nextQuestionId,
      textQuestionKey: {opsKey: textQuestion},
      questionPhotoKey: questionPhoto,
      choicesKey: choices.map((choice) => {opsKey: choice}).toList(),
      rightChoiceKey: rightChoice,
      isEditedKey: isEdited,
      hintKey: hint,
      hintPhotoKey: hintPhoto,
    };
  }
}
