// lib/features/lessons/presentation/cubit/lessons_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

//!base state
sealed class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object> get props => [];
}

//! regular lessons state
final class LessonsInitial extends LessonsState {
  const LessonsInitial();
}

final class LessonsLoading extends LessonsInitial {}

final class LessonsLoaded extends LessonsInitial {
  final List<LessonEntity> lessons;
  final int questionsCount;
  final int answeredQuestionsCount;

  const LessonsLoaded({
    required this.lessons,
    this.questionsCount = 0,
    this.answeredQuestionsCount = 0,
  });

  @override
  List<Object> get props => [lessons, questionsCount, answeredQuestionsCount];
}

final class LessonsError extends LessonsInitial {
  final String message;

  const LessonsError(this.message);

  @override
  List<Object> get props => [message];
}

enum ScreenType {
  regularLessons,
  favLessons,
  editedLessons,
  incorrectLessons,
}
