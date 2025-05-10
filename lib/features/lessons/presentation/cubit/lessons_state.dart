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

  const LessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
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
