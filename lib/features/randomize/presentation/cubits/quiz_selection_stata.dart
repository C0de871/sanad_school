// State for the Quiz Selection
import 'package:equatable/equatable.dart';

import '../../../questions/presentation/questions_screen.dart';

class QuizSelectionState extends Equatable {
  final List<String> selectedLessons;
  final List<String> selectedTags;
  final List<QuestionType> selectedTypes;
  final int requestedQuestionCount;
  final int availableQuestionCount;
  final bool isLoading;
  final String? errorMessage;

  const QuizSelectionState({
    this.selectedLessons = const [],
    this.selectedTags = const [],
    this.selectedTypes = const [],
    this.requestedQuestionCount = 0,
    this.availableQuestionCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  QuizSelectionState copyWith({
    List<String>? selectedLessons,
    List<String>? selectedTags,
    List<QuestionType>? selectedTypes,
    int? requestedQuestionCount,
    int? availableQuestionCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QuizSelectionState(
      selectedLessons: selectedLessons ?? this.selectedLessons,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      requestedQuestionCount: requestedQuestionCount ?? this.requestedQuestionCount,
      availableQuestionCount: availableQuestionCount ?? this.availableQuestionCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedLessons,
        selectedTags,
        selectedTypes,
        requestedQuestionCount,
        availableQuestionCount,
        isLoading,
        errorMessage,
      ];
}
