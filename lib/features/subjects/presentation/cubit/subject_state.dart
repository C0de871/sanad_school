part of 'subject_cubit.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectSuccess extends SubjectState {
  final List<SubjectEntity> subjects;

  const SubjectSuccess(this.subjects);

  @override
  List<Object> get props => [subjects];
}

class SubjectFailure extends SubjectState {
  final String message;

  const SubjectFailure(this.message);

  @override
  List<Object> get props => [message];
}
