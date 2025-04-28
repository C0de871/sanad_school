// lib/features/lessons/presentation/cubit/lessons_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

sealed class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object> get props => [];
}

final class LessonsInitial extends LessonsState {}

final class LessonsLoading extends LessonsState {}

final class LessonsLoaded extends LessonsState {
  final List<LessonEntity> lessons;

  const LessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}

final class LessonsError extends LessonsState {
  final String message;

  const LessonsError(this.message);

  @override
  List<Object> get props => [message];
}