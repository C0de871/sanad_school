part of 'subject_sync_cubit.dart';

sealed class SubjectSyncState extends Equatable {
  const SubjectSyncState();

  @override
  List<Object> get props => [];
}

class SubjectSyncInitial extends SubjectSyncState {}

class SubjectSyncLoading extends SubjectSyncState {}

class LessonsSuccess extends SubjectSyncState {
  final List<LessonEntity> lessons;

  const LessonsSuccess({required this.lessons});

  @override
  List<Object> get props => [lessons];
}

class SubjectSyncSucessAndFetchLessonsSuccess extends LessonsSuccess {
  final SubjectSyncEntity subjectSync;
  final String message;

  const SubjectSyncSucessAndFetchLessonsSuccess(
    this.subjectSync, {
    required super.lessons,
    required this.message,
  });

  @override
  List<Object> get props => [...super.props, subjectSync, message];
}

class SubjectSyncFailedAndFetchLessonsSuccess extends LessonsSuccess {
  final String message;

  const SubjectSyncFailedAndFetchLessonsSuccess({
    required super.lessons,
    required this.message,
  });

  @override
  List<Object> get props => [...super.props, message];
}

class SubjectSyncFailure extends SubjectSyncState {
  final String message;

  const SubjectSyncFailure(this.message);

  @override
  List<Object> get props => [message];
}
