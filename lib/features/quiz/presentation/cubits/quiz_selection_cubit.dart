// Cubit to manage the quiz selection state
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../lessons/domain/entities/lesson_entity.dart';
import '../../../lessons/domain/entities/question_type_entity.dart';
import '../../../tags/domain/entities/tag_entity.dart';
import '../../domain/usecases/get_available_lessons.dart';
import '../../domain/usecases/get_available_tags.dart';
import '../../domain/usecases/get_available_types.dart';
import '../../domain/usecases/get_available_questions_count.dart';
import '../../domain/usecases/get_quiz_questions.dart';
import '../screens/arg/screen_arg.dart';
import 'quiz_selection_state.dart';

class QuizSelectionCubit extends Cubit<QuizSelectionState> {
  final GetQuizQuestionsUsecase getQuizQuestionsUsecase;
  final GetAvailableLessonsUsecase getAvailableLessonsUsecase;
  final GetAvailableTagsUsecase getAvailableTagsUsecase;
  final GetAvailableTypesUsecase getAvailableTypesUsecase;
  final GetAvailableQuestionsCountUsecase getAvailableQuestionsCountUsecase;

  final QuizScreenArgs quizScreenArgs;

  QuizSelectionCubit({required this.quizScreenArgs})
      : getAvailableLessonsUsecase = getIt(),
        getAvailableTagsUsecase = getIt(),
        getAvailableTypesUsecase = getIt(),
        getQuizQuestionsUsecase = getIt(),
        getAvailableQuestionsCountUsecase = getIt(),
        super(const QuizSelectionState()) {
    countController.text = '0';
    initPage();
  }

  // Mock data for demonstration purposes
  // final List<String> allLessons = List.generate(50, (index) => 'درس ${index + 1}');
  final TextEditingController countController = TextEditingController();
  // final List<String> allTags = List.generate(100, (index) => 'وسم ${index + 1}');
  // final Map<String, List<QuestionType>> lessonTypes = {
  //   'درس 1': [QuestionType.multipleChoice, QuestionType.written],
  //   'درس 2': [QuestionType.multipleChoice],
  //   // Add more mappings as needed
  // };

  Future<void> initPage() async {
    emit(state.copyWith(
      availableLessonsStatus: QuizSelectionStatus.loading,
      availableTagsStatus: QuizSelectionStatus.loading,
      availableTypesStatus: QuizSelectionStatus.loading,
      availableQuestionCountStatus: QuizSelectionStatus.loading,
    ));

    final availableLessonsResponse = getAvailableLessonsUsecase.call(GetAvailableLessonsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedTypeIds: state.selectedTypes,
      selectedTagIds: state.selectedTags,
    ));

    final availableTagsResponse = getAvailableTagsUsecase.call(GetAvailableTagsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: state.selectedLessons,
      selectedTypeIds: state.selectedTypes,
    ));

    final availableTypesResponse = getAvailableTypesUsecase.call(GetAvailableTypesParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: state.selectedLessons,
      selectedTagIds: state.selectedTags,
    ));

    final availableQuestionsCountReponse = getAvailableQuestionsCountUsecase.call(QuizFilterParams(
      subjectId: quizScreenArgs.subjectId,
      lessonIds: state.selectedLessons,
      typeIds: state.selectedTypes,
      tagIds: state.selectedTags,
    ));
    final [availableLessons, availableTags, availableTypes, availableQuestionsCount] = await Future.wait([
      availableLessonsResponse,
      availableTagsResponse,
      availableTypesResponse,
      availableQuestionsCountReponse,
    ]);

    emit(state.copyWith(
      availableLessons: availableLessons as List<LessonEntity>?,
      availableTags: availableTags as List<TagEntity>?,
      availableTypes: availableTypes as List<QuestionTypeEntity>?,
      availableQuestionCount: availableQuestionsCount as int?,
      availableLessonsStatus: QuizSelectionStatus.loaded,
      availableTagsStatus: QuizSelectionStatus.loaded,
      availableTypesStatus: QuizSelectionStatus.loaded,
      availableQuestionCountStatus: QuizSelectionStatus.loaded,
    ));
  }

  Future<void> toggleLesson(int lessonId) async {
    final currentLessons = List<int>.from(state.selectedLessons);
    if (currentLessons.contains(lessonId)) {
      currentLessons.remove(lessonId);
    } else {
      currentLessons.add(lessonId);
    }

    final availableTagsResponse = getAvailableTagsUsecase.call(GetAvailableTagsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: currentLessons,
      selectedTypeIds: state.selectedTypes,
    ));

    final availableTypesResponse = getAvailableTypesUsecase.call(GetAvailableTypesParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: currentLessons,
      selectedTagIds: state.selectedTags,
    ));

    final availableQuestionsCountResponse = getAvailableQuestionsCountUsecase.call(QuizFilterParams(
      subjectId: quizScreenArgs.subjectId,
      lessonIds: currentLessons,
      typeIds: state.selectedTypes,
      tagIds: state.selectedTags,
    ));

    final [availableTags, availableTypes, availableQuestionsCount] = await Future.wait([
      availableTagsResponse,
      availableTypesResponse,
      availableQuestionsCountResponse,
    ]);

    emit(state.copyWith(
      availableTags: availableTags as List<TagEntity>?,
      availableTypes: availableTypes as List<QuestionTypeEntity>?,
      availableQuestionCount: availableQuestionsCount as int?,
      availableTagsStatus: QuizSelectionStatus.loaded,
      availableTypesStatus: QuizSelectionStatus.loaded,
      availableQuestionCountStatus: QuizSelectionStatus.loaded,
      selectedLessons: currentLessons,
    ));
  }

  void toggleTag(int tagId) async {
    final currentTags = List<int>.from(state.selectedTags);
    if (currentTags.contains(tagId)) {
      currentTags.remove(tagId);
    } else {
      currentTags.add(tagId);
    }

    final availableTypesResponse = getAvailableTypesUsecase.call(GetAvailableTypesParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: state.selectedLessons,
      selectedTagIds: currentTags,
    ));

    final availableQuestionsCountResponse = getAvailableQuestionsCountUsecase.call(QuizFilterParams(
      subjectId: quizScreenArgs.subjectId,
      lessonIds: state.selectedLessons,
      typeIds: state.selectedTypes,
      tagIds: currentTags,
    ));

    final availableLessonsResponse = getAvailableLessonsUsecase.call(GetAvailableLessonsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedTagIds: currentTags,
      selectedTypeIds: state.selectedTypes,
    ));

    final [availableTypes, availableQuestionsCount, availableLessons] = await Future.wait([
      availableTypesResponse,
      availableQuestionsCountResponse,
      availableLessonsResponse,
    ]);

    emit(state.copyWith(
      availableTypes: availableTypes as List<QuestionTypeEntity>?,
      availableQuestionCount: availableQuestionsCount as int?,
      availableLessons: availableLessons as List<LessonEntity>?,
      availableTypesStatus: QuizSelectionStatus.loaded,
      availableQuestionCountStatus: QuizSelectionStatus.loaded,
      availableLessonsStatus: QuizSelectionStatus.loaded,
      selectedTags: currentTags,
    ));
  }

  void toggleQuestionType(int typeId) async {
    final currentTypes = List<int>.from(state.selectedTypes);
    if (currentTypes.contains(typeId)) {
      currentTypes.remove(typeId);
    } else {
      currentTypes.add(typeId);
    }

    final availableTagsResponse = getAvailableTagsUsecase.call(GetAvailableTagsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedLessonIds: state.selectedLessons,
      selectedTypeIds: currentTypes,
    ));

    final availableLessonsResponse = getAvailableLessonsUsecase.call(GetAvailableLessonsParams(
      subjectId: quizScreenArgs.subjectId,
      selectedTagIds: state.selectedTags,
      selectedTypeIds: currentTypes,
    ));

    final availableQuestionsCountResponse = getAvailableQuestionsCountUsecase.call(QuizFilterParams(
      subjectId: quizScreenArgs.subjectId,
      lessonIds: state.selectedLessons,
      typeIds: currentTypes,
      tagIds: state.selectedTags,
    ));

    final [availableTags, availableLessons, availableQuestionsCount] = await Future.wait([
      availableTagsResponse,
      availableLessonsResponse,
      availableQuestionsCountResponse,
    ]);

    emit(state.copyWith(
      availableTags: availableTags as List<TagEntity>?,
      availableLessons: availableLessons as List<LessonEntity>?,
      availableQuestionCount: availableQuestionsCount as int?,
      availableTagsStatus: QuizSelectionStatus.loaded,
      availableLessonsStatus: QuizSelectionStatus.loaded,
      availableQuestionCountStatus: QuizSelectionStatus.loaded,
      selectedTypes: currentTypes,
    ));
  }

  void updateRequestedQuestionCount(int count) {
    if (count > state.availableQuestionCount || count < 0) {
      return;
    }
    countController.text = count.toString();
    emit(state.copyWith(requestedQuestionCount: count));
  }
}
