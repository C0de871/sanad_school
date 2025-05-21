// State for the Quiz Selection
import 'package:equatable/equatable.dart';

import '../../../lessons/domain/entities/lesson_entity.dart';
import '../../../tags/domain/entities/tag_entity.dart';
import '../../../lessons/domain/entities/question_type_entity.dart';
class QuizSelectionState extends Equatable {
  final List<int> selectedLessons;
  final List<int> selectedTags;
  final List<int> selectedTypes;

  final List<LessonEntity> availableLessons;
  final List<TagEntity> availableTags;
  final List<QuestionTypeEntity> availableTypes;
  final int requestedQuestionCount;
  final int availableQuestionCount;

  final QuizSelectionStatus availableLessonsStatus;
  final QuizSelectionStatus availableTagsStatus;
  final QuizSelectionStatus availableTypesStatus;
  final QuizSelectionStatus availableQuestionCountStatus;

  const QuizSelectionState({
    this.selectedLessons = const [],
    this.selectedTags = const [],
    this.selectedTypes = const [],
    this.availableLessons = const [],
    this.availableTags = const [],
    this.availableTypes = const [],
    this.requestedQuestionCount = 0,
    this.availableQuestionCount = 0,
    this.availableLessonsStatus = QuizSelectionStatus.initial,
    this.availableTagsStatus = QuizSelectionStatus.initial,
    this.availableTypesStatus = QuizSelectionStatus.initial,
    this.availableQuestionCountStatus = QuizSelectionStatus.initial,
  });

  QuizSelectionState copyWith({
    List<int>? selectedLessons,
    List<int>? selectedTags,
    List<int>? selectedTypes,
    int? requestedQuestionCount,
    int? availableQuestionCount,
    QuizSelectionStatus? availableLessonsStatus,
    QuizSelectionStatus? availableTagsStatus,
    QuizSelectionStatus? availableTypesStatus,
    List<LessonEntity>? availableLessons,
    List<TagEntity>? availableTags,
    List<QuestionTypeEntity>? availableTypes,
    QuizSelectionStatus? availableQuestionCountStatus,
  }) {
    return QuizSelectionState(
      selectedLessons: selectedLessons ?? this.selectedLessons,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      requestedQuestionCount: requestedQuestionCount ?? this.requestedQuestionCount,
      availableQuestionCount: availableQuestionCount ?? this.availableQuestionCount,
      availableLessonsStatus: availableLessonsStatus ?? this.availableLessonsStatus,
      availableTagsStatus: availableTagsStatus ?? this.availableTagsStatus,
      availableTypesStatus: availableTypesStatus ?? this.availableTypesStatus,
      availableLessons: availableLessons ?? this.availableLessons,
      availableTags: availableTags ?? this.availableTags,
      availableTypes: availableTypes ?? this.availableTypes,
      availableQuestionCountStatus: availableQuestionCountStatus ?? this.availableQuestionCountStatus,
    );
  }

  @override
  List<Object?> get props => [
        selectedLessons,
        selectedTags,
        selectedTypes,
        requestedQuestionCount,
        availableQuestionCount,
        availableLessons,
        availableTags,
        availableTypes,
        availableLessonsStatus,
        availableTagsStatus,
        availableTypesStatus,
        availableQuestionCountStatus,
      ];
}

enum QuizSelectionStatus {
  initial,
  loading,
  loaded,
  error,
}
