// lib/features/subject/presentation/cubit/tag_state.dart
part of 'tag_cubit.dart';

sealed class TagState extends Equatable {
  const TagState();

  @override
  List<Object> get props => [];
}

class TagInitial extends TagState {}

class TagLoading extends TagState {}

class TagLoaded extends TagState {
  final List<TagEntity> tags;

  const TagLoaded({required this.tags});

  @override
  List<Object> get props => [tags];
}

class TagError extends TagState {
  final String message;

  const TagError({required this.message});

  @override
  List<Object> get props => [message];
}
