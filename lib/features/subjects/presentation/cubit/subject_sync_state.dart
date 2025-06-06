part of 'subject_sync_cubit.dart';

sealed class SubjectSyncState extends Equatable {
  const SubjectSyncState();

  @override
  List<Object> get props => [];
}

class SubjectSyncInitial extends SubjectSyncState {}

class SubjectSyncLoading extends SubjectSyncState {}

class SubjectSyncSuccess extends SubjectSyncState {
  final bool isSynced;

  const SubjectSyncSuccess(this.isSynced);

  @override
  List<Object> get props => [isSynced];
}

class SubjectSyncFailure extends SubjectSyncState {
  final String message;

  const SubjectSyncFailure(this.message);

  @override
  List<Object> get props => [message];
}
