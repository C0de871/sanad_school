// Cubit to manage the quiz selection state
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../questions/presentation/questions_screen.dart';
import '../../data/mock_repository.dart';
import 'quiz_selection_stata.dart';

class QuizSelectionCubit extends Cubit<QuizSelectionState> {
  final QuestionRepository questionRepository;

  QuizSelectionCubit({required this.questionRepository}) : super(const QuizSelectionState()) {
    countController.text = '0';
  }

  // Mock data for demonstration purposes
  final List<String> allLessons = List.generate(50, (index) => 'درس ${index + 1}');
  final TextEditingController countController = TextEditingController();
  final List<String> allTags = List.generate(100, (index) => 'وسم ${index + 1}');
  final Map<String, List<QuestionType>> lessonTypes = {
    'درس 1': [QuestionType.multipleChoice, QuestionType.written],
    'درس 2': [QuestionType.multipleChoice],
    // Add more mappings as needed
  };

  void toggleLesson(String lesson) {
    final currentLessons = List<String>.from(state.selectedLessons);
    if (currentLessons.contains(lesson)) {
      currentLessons.remove(lesson);
    } else {
      currentLessons.add(lesson);
    }
    emit(state.copyWith(selectedLessons: currentLessons));
    _updateAvailableQuestionCount();
  }

  void toggleTag(String tag) {
    final currentTags = List<String>.from(state.selectedTags);
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else {
      currentTags.add(tag);
    }
    emit(state.copyWith(selectedTags: currentTags));
    _updateAvailableQuestionCount();
  }

  void toggleQuestionType(QuestionType type) {
    final currentTypes = List<QuestionType>.from(state.selectedTypes);
    if (currentTypes.contains(type)) {
      currentTypes.remove(type);
    } else {
      currentTypes.add(type);
    }
    emit(state.copyWith(selectedTypes: currentTypes));
    _updateAvailableQuestionCount();
  }

  void updateRequestedQuestionCount(int count) {
    if (count > state.availableQuestionCount || count < 0) {
      return;
    }
    countController.text = count.toString();
    emit(state.copyWith(requestedQuestionCount: count));
  }

  Future<void> _updateAvailableQuestionCount() async {
    emit(state.copyWith(isLoading: true));
    try {
      // In a real app, you'd query your repository for the count
      final count = await questionRepository.getAvailableQuestionsCount(
        state.selectedLessons,
        state.selectedTags,
        state.selectedTypes,
      );
      emit(state.copyWith(
        availableQuestionCount: count,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'فشل في تحديث عدد الأسئلة المتاحة: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  Future<List<Question>> startQuiz() async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.requestedQuestionCount > state.availableQuestionCount) {
        emit(state.copyWith(
          errorMessage: 'عدد الأسئلة المطلوبة أكبر من عدد الأسئلة المتاحة',
          isLoading: false,
        ));
        return [];
      }

      final questions = await questionRepository.getRandomQuestions(
        state.selectedLessons,
        state.selectedTags,
        state.selectedTypes,
        state.requestedQuestionCount,
      );
      emit(state.copyWith(isLoading: false));
      return questions;
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'فشل في بدء الاختبار: ${e.toString()}',
        isLoading: false,
      ));
      return [];
    }
  }
}
