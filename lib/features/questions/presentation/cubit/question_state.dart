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
  final Map<int, bool> isFavorite;
  final Map<int, String> userNotes;
  final Map<int, bool> expandedImages;  
  final Map<int, bool> expandedAnswers;

  const QuestionSuccess({
    required this.questions,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.seconds = 0,
    this.isTimerRunning = false,
    this.userAnswers = const [],
    this.isCorrect = const [],
    this.isFavorite = const {},
    this.userNotes = const {},
    this.expandedImages = const {},
    this.expandedAnswers = const {},
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
        isFavorite,
        userNotes,
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
    Map<int, bool>? isFavorite,
    Map<int, String>? userNotes,
    Map<int, bool>? expandedImages,
    Map<int, bool>? expandedAnswers,
  }) {
    return QuestionSuccess(
      questions: questions ?? this.questions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      seconds: seconds ?? this.seconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      userAnswers: userAnswers ?? this.userAnswers,
      isCorrect: isCorrect ?? this.isCorrect,
      isFavorite: isFavorite ?? this.isFavorite,
      userNotes: userNotes ?? this.userNotes,
      expandedImages: expandedImages ?? this.expandedImages,
      expandedAnswers: expandedAnswers ?? this.expandedAnswers,
    );
  }
}

class QuestionFailure extends QuestionState {
  final String error;

  const QuestionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
