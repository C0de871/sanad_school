// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../domain/entities/question_entity.dart';

sealed class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionSuccess extends QuestionState {
  final List<QuestionEntity> questions;
  final int correctAnswersCount; // User's correct answers count
  final int wrongAnswersCount; // User's wrong answers count
  final int seconds;
  final bool isTimerRunning;
  final List<int?> userAnswers; // User's answers
  final List<bool?> isRightList; // list to store if the answer of the user is right or not
  final Map<int, bool> expandedImages; //image expanded status
  final Map<int, bool> expandedAnswers; //answer expanded status
  final int unAnsweredQuestionsCount; // User's unanswered questions

  const QuestionSuccess({
    required this.questions,
    this.correctAnswersCount = 0,
    this.wrongAnswersCount = 0,
    this.seconds = 0,
    this.isTimerRunning = false,
    this.userAnswers = const [],
    this.isRightList = const [],
    this.expandedImages = const {},
    this.expandedAnswers = const {},
    this.unAnsweredQuestionsCount = 0,
  });

  @override
  List<Object?> get props => [
        questions,
        correctAnswersCount,
        wrongAnswersCount,
        seconds,
        isTimerRunning,
        userAnswers,
        isRightList,
        expandedImages,
        expandedAnswers,
      ];

  QuestionSuccess copyWith({
    List<QuestionEntity>? questions,
    int? correctAnswers,
    int? wrongAnswers,
    int? seconds,
    bool? isTimerRunning,
    bool? isInitialized,
    List<int?>? userAnswers,
    List<bool?>? isCorrect,
    Map<int, bool>? expandedImages,
    Map<int, bool>? expandedAnswers,
    int? unAnsweredQuestions,
  }) {
    return QuestionSuccess(
      questions: questions ?? this.questions,
      correctAnswersCount: correctAnswers ?? this.correctAnswersCount,
      wrongAnswersCount: wrongAnswers ?? this.wrongAnswersCount,
      seconds: seconds ?? this.seconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      userAnswers: userAnswers ?? this.userAnswers,
      isRightList: isCorrect ?? this.isRightList,
      expandedImages: expandedImages ?? this.expandedImages,
      expandedAnswers: expandedAnswers ?? this.expandedAnswers,
      unAnsweredQuestionsCount: unAnsweredQuestions ?? this.unAnsweredQuestionsCount,
    );
  }
}

class QuestionFailure extends QuestionState {
  final String error;

  const QuestionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
