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
  final int correctAnswers;
  final int wrongAnswers;
  final int seconds;
  final bool isTimerRunning;
  final List<int?> userAnswers;
  final List<bool?> isCorrect;
  final Map<int, bool> expandedImages;
  final Map<int, bool> expandedAnswers;
  final int unAnsweredQuestions;


  const QuestionSuccess({
    required this.questions,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.seconds = 0,
    this.isTimerRunning = false,
    this.userAnswers = const [],
    this.isCorrect = const [],
    this.expandedImages = const {},
    this.expandedAnswers = const {},
    this.unAnsweredQuestions = 0,
  });

  @override
  List<Object?> get props => [
        questions,
        correctAnswers,
        wrongAnswers,
        seconds,
        isTimerRunning,
        userAnswers,
        isCorrect,
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
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      seconds: seconds ?? this.seconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      userAnswers: userAnswers ?? this.userAnswers,
      isCorrect: isCorrect ?? this.isCorrect,
      expandedImages: expandedImages ?? this.expandedImages,
      expandedAnswers: expandedAnswers ?? this.expandedAnswers,
      unAnsweredQuestions: unAnsweredQuestions ?? this.unAnsweredQuestions,
    );
  }
}

class QuestionFailure extends QuestionState {
  final String error;

  const QuestionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
