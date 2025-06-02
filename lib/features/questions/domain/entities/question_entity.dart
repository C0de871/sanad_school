import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../presentation/questions_screen.dart';

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
  final bool isEdited;
  final List<Map<String, dynamic>>? hint;
  final String? hintPhoto;
  final QuestionTypeEnum type;
  final bool isFavorite;
  final bool answerStatus;
  final String? note;
  final Uint8List? downloadedHintPhoto;
  final Uint8List? downloadedQuestionPhoto;
  final bool isAnswered;
  final bool isCorrected;
  final bool isAnsweredCorrectly;
  final int? userAnswer;

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
    this.isFavorite = false,
    this.answerStatus = false,
    this.note,
    this.downloadedHintPhoto,
    this.downloadedQuestionPhoto,
    this.isAnswered = false,
    this.isCorrected = false,
    this.isAnsweredCorrectly = false,
    this.userAnswer,
  }) : type = typeId <= 2 ? QuestionTypeEnum.multipleChoice : QuestionTypeEnum.written;

  int get adjustedRightChoice => rightChoice - 1;

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
        isFavorite,
        answerStatus,
        note,
        downloadedHintPhoto,
        downloadedQuestionPhoto,
        isAnswered,
        isCorrected,
        isAnsweredCorrectly,
      ];

  QuestionEntity copyWith({
    bool? isFavorite,
    bool? answerStatus,
    String? note,
    Uint8List? downloadedHintPhoto,
    Uint8List? downloadedQuestionPhoto,
    bool? isAnswered,
    bool? isCorrected,
    bool? isAnsweredCorrectly,
  }) {
    return QuestionEntity(
      id: id,
      uuid: uuid,
      questionGroupId: questionGroupId,
      order: order,
      typeId: typeId,
      textQuestion: textQuestion,
      questionPhoto: questionPhoto,
      choices: choices,
      rightChoice: rightChoice,
      isEdited: isEdited,
      hint: hint,
      hintPhoto: hintPhoto,
      isFavorite: isFavorite ?? this.isFavorite,
      answerStatus: answerStatus ?? this.answerStatus,
      note: note ?? this.note,
      downloadedHintPhoto: downloadedHintPhoto ?? this.downloadedHintPhoto,
      downloadedQuestionPhoto: downloadedQuestionPhoto ?? this.downloadedQuestionPhoto,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrected: isCorrected ?? this.isCorrected,
      isAnsweredCorrectly: isAnsweredCorrectly ?? this.isAnsweredCorrectly,
    );
  }
}
