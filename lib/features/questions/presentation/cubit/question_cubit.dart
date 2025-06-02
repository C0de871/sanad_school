import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../../main.dart';
import '../../../quiz/domain/usecases/get_quiz_questions.dart';
import '../../domain/usecases/get_question_hint_photo.dart';
import '../../domain/usecases/get_question_photo.dart';
import '../../domain/usecases/get_questions_in_lesson_by_type_use_case.dart';
import '../../domain/usecases/get_questions_in_subject_by_tag.dart';
import '../../domain/usecases/question_usecases.dart';
import '../../domain/usecases/update_question_answered_correctly_usecase.dart';
import '../../domain/usecases/update_question_answered_usecase.dart';
import '../../domain/usecases/update_question_corrected_usecase.dart';
import '../arg/question_from_quiz_arg.dart';
import '../questions_screen.dart';
import 'question_state.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../domain/entities/question_entity.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetQuestionsInLessonByTypeUseCase _getLessonQuestionsByTypeUseCase;
  final GetQuestionsInSubjectByTagUseCase _getQuestionsInSubjectByTagUseCase;
  final GetEditedQuestionsByLessonUseCase _getEditedQuestionsByLessonUseCase;
  final GetIncorrectAnswerGroupsQuestionsUseCase
      _getIncorrectQuestionsByLessonUseCase;
  final GetFavoriteGroupsQuestionsUseCase _getFavQuestionsByLessonUseCase;
  final SaveQuestionNoteUseCase _saveQuestionNoteUseCase;
  final ToggleQuestionFavoriteUseCase _toggleQuestionFavoriteUseCase;
  final ToggleQuestionIncorrectAnswerUseCase _toggleQuestionCorrectUseCase;
  final GetQuestionPhoto _getQuestionPhotoUseCase;
  final GetQuestionHintPhoto _getQuestionHintPhotoUseCase;
  final GetQuizQuestionsUsecase _getQuizQuestionsUseCase;
  final UpdateQuestionAnsweredUsecase _updateQuestionAnsweredUsecase;
  final UpdateQuestionAnsweredCorrectlyUsecase
      _updateQuestionAnsweredCorrectlyUsecase;
  final UpdateQuestionCorrectedUsecase _updateQuestionCorrectedUsecase;
  Timer? timer;
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  List<Map<String, dynamic>> questionsController = [];
  List<Map<String, dynamic>> questionsScrollController = [];
  List<Map<String, dynamic>> questionsFocusNode = [];
  static String questionControllersNodeKey = "question-controller";
  static String hintControllersNodeKey = "hint-controller";
  static String answersControllerNodeKey = "answers-controller";

  QuestionCubit()
      : _getLessonQuestionsByTypeUseCase = getIt(),
        _getQuestionsInSubjectByTagUseCase = getIt(),
        _getEditedQuestionsByLessonUseCase = getIt(),
        _getIncorrectQuestionsByLessonUseCase = getIt(),
        _getFavQuestionsByLessonUseCase = getIt(),
        _saveQuestionNoteUseCase = getIt(),
        _toggleQuestionFavoriteUseCase = getIt(),
        _toggleQuestionCorrectUseCase = getIt(),
        _getQuestionPhotoUseCase = getIt(),
        _getQuestionHintPhotoUseCase = getIt(),
        _getQuizQuestionsUseCase = getIt(),
        _updateQuestionAnsweredUsecase = getIt(),
        _updateQuestionAnsweredCorrectlyUsecase = getIt(),
        _updateQuestionCorrectedUsecase = getIt(),
        super(QuestionInitial()) {
    // disableScreenshot(); 
  }

  FocusNode getQuestionFocusNode(int questionIndex) {
    return questionsFocusNode[questionIndex][questionControllersNodeKey];
  }

  ScrollController getQuestionScrollController(int questionIndex) {
    return questionsScrollController[questionIndex][questionControllersNodeKey];
  }

  QuillController getQuestionController(int questionIndex) {
    return questionsController[questionIndex][questionControllersNodeKey];
  }

  FocusNode getHintFocusNode(int questionIndex) {
    return questionsFocusNode[questionIndex][hintControllersNodeKey];
  }

  ScrollController getHintScrollController(int questionIndex) {
    return questionsScrollController[questionIndex][hintControllersNodeKey];
  }

  QuillController getHintController(int questionIndex) {
    return questionsController[questionIndex][hintControllersNodeKey];
  }

  QuillController getAnswerController(int questionIndex, int answerIndex) {
    return questionsController[questionIndex][answersControllerNodeKey]
        [answerIndex];
  }

  FocusNode getAnswerFocusNode(int questionIndex, int answerIndex) {
    return questionsFocusNode[questionIndex][answersControllerNodeKey]
        [answerIndex];
  }

  ScrollController getAnswerScrollController(
      int questionIndex, int answerIndex) {
    return questionsScrollController[questionIndex][answersControllerNodeKey]
        [answerIndex];
  }

  void _initializeControllers(List<QuestionEntity> questions) {
    questionsController = List.generate(questions.length, (questionIndex) {
      return {
        questionControllersNodeKey: QuillController(
          document: Document.fromJson(questions[questionIndex].textQuestion),
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        ),
        hintControllersNodeKey: QuillController(
          document: (questions[questionIndex].hint == null ||
                  questions[questionIndex].hint!.isEmpty)
              ? Document()
              : Document.fromJson(questions[questionIndex].hint!),
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        ),
        answersControllerNodeKey: List.generate(
          questions[questionIndex].choices.length,
          (choiceIndex) => QuillController(
            document: Document.fromJson(
                questions[questionIndex].choices[choiceIndex]),
            selection: const TextSelection.collapsed(offset: 0),
            readOnly: true,
          ),
        ),
      };
    });

    questionsScrollController = List.generate(questions.length, (index) {
      return {
        questionControllersNodeKey: ScrollController(),
        hintControllersNodeKey: ScrollController(),
        answersControllerNodeKey:
            List.filled(questions[index].choices.length, ScrollController()),
      };
    });

    questionsFocusNode = List.generate(questions.length, (index) {
      return {
        questionControllersNodeKey: FocusNode(),
        hintControllersNodeKey: FocusNode(),
        answersControllerNodeKey:
            List.filled(questions[index].choices.length, FocusNode()),
      };
    });
    emit(QuestionSuccess(
      questions: questions,
      userAnswers: List.generate(questions.length, (index) {
        return questions[index].userAnswer;
      }),
      isRightList: List.generate(questions.length, (index) {
        if (questions[index].isCorrected) {
          return questions[index].isAnsweredCorrectly;
        }
        return null;
      }),
      wrongAnswersCount: questions
          .where((question) =>
              question.isCorrected && !question.isAnsweredCorrectly)
          .length,
      correctAnswersCount: questions
          .where((question) =>
              question.isCorrected && question.isAnsweredCorrectly)
          .length,
    ));
  }

  Future<void> getQuestionsByLessonAndType({
    required int lessonId,
    required int? typeId,
  }) async {
    emit(QuestionLoading());
    QuestionsInLessonWithTypeParams params =
        QuestionsInLessonWithTypeParams(lessonId: lessonId, typeId: typeId);
    final result = await _getLessonQuestionsByTypeUseCase.call(
      params: params,
    );
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      _initializeControllers,
    );
  }

  Future<void> getSubjectQuestionsByTag({
    required int tagId,
  }) async {
    emit(QuestionLoading());
    QuestionsInSubjectByTag params = QuestionsInSubjectByTag(tagId: tagId);
    final result = await _getQuestionsInSubjectByTagUseCase.call(
      params: params,
    );
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      _initializeControllers,
    );
  }

  void startTimer() {
    if (state is! QuestionSuccess) return;
    final currentState = state as QuestionSuccess;
    emit(currentState.copyWith(isTimerRunning: true));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Get the current state each time the timer fires
      final updatedState = state as QuestionSuccess;
      emit(updatedState.copyWith(seconds: updatedState.seconds + 1));
    });
  }

  void stopTimer() {
    if (state is! QuestionSuccess) return;
    final currentState = state as QuestionSuccess;
    emit(currentState.copyWith(isTimerRunning: false));
    timer?.cancel();
  }

  void resetTimer() {
    if (state is! QuestionSuccess) return;
    final currentState = state as QuestionSuccess;
    emit(currentState.copyWith(seconds: 0, isTimerRunning: false));
    timer?.cancel();
  }

  void resetAnswers() {
    if (state is! QuestionSuccess) return;
    final currentState = state as QuestionSuccess;

    for (int i = 0; i < currentState.questions.length; i++) {
      _updateQuestionCorrectedUsecase.call(UpdateQuestionCorrectedParams(
        questionId: currentState.questions[i].id,
        isCorrected: false,
      ));

      _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
        questionId: currentState.questions[i].id,
        isAnswered: false,
        userAnswer: null,
      ));

      _updateQuestionAnsweredCorrectlyUsecase
          .call(UpdateQuestionAnsweredCorrectlyParams(
        questionId: currentState.questions[i].id,
        isAnsweredCorrectly: false,
      ));
    }

    emit(currentState.copyWith(
      userAnswers:
          List.generate(currentState.questions.length, (index) => null),
      isCorrect: List.generate(currentState.questions.length, (index) => null),
      correctAnswers: 0,
      wrongAnswers: 0,
    ));
  }

// Extract common state checking logic
  QuestionSuccess? _getCurrentState(dynamic state) {
    return state is QuestionSuccess ? state : null;
  }

  // Extract answer evaluation logic
  AnswerResult _evaluateAnswer(QuestionEntity question, int? userAnswer) {
    if (userAnswer == null) {
      return AnswerResult(isCorrect: false, hasAnswer: false);
    }

    if (question.type == QuestionTypeEnum.multipleChoice) {
      return AnswerResult(
        isCorrect: userAnswer == question.adjustedRightChoice,
        hasAnswer: true,
      );
    }

    return AnswerResult(isCorrect: userAnswer == 1, hasAnswer: true);
  }

  // Extract score updating logic
  ScoreUpdate _updateScores({
    required int currentCorrect,
    required int currentWrong,
    required bool wasCorrect,
    required bool isCorrect,
    required bool hadAnswer,
  }) {
    int correctDelta = 0;
    int wrongDelta = 0;

    if (!hadAnswer) {
      // New answer
      isCorrect ? correctDelta++ : wrongDelta++;
    } else if (wasCorrect != isCorrect) {
      // Answer changed
      if (isCorrect) {
        correctDelta++;
        wrongDelta--;
      } else {
        wrongDelta++;
        correctDelta--;
      }
    }

    return ScoreUpdate(
      correctAnswers: currentCorrect + correctDelta,
      wrongAnswers: currentWrong + wrongDelta,
    );
  }

  void checkAllAnswers() {
    final currentState = _getCurrentState(state);
    if (currentState == null) return;

    int correctAnswers = 0;
    int wrongAnswers = 0;
    List<bool?> isRightListUpdated = List<bool?>.from(currentState.isRightList);

    for (int i = 0; i < currentState.questions.length; i++) {
      final result = _evaluateAnswer(
          currentState.questions[i], currentState.userAnswers[i]);

      _updateQuestionCorrectedUsecase.call(UpdateQuestionCorrectedParams(
        questionId: currentState.questions[i].id,
        isCorrected: true,
      ));

      _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
        questionId: currentState.questions[i].id,
        isAnswered: true,
        userAnswer: currentState.userAnswers[i],
      ));

      _updateQuestionAnsweredCorrectlyUsecase
          .call(UpdateQuestionAnsweredCorrectlyParams(
        questionId: currentState.questions[i].id,
        isAnsweredCorrectly: result.isCorrect,
      ));

      isRightListUpdated[i] = result.isCorrect;
      result.isCorrect ? correctAnswers++ : wrongAnswers++;

      _updateQuestionStatus(currentState.questions[i].id, result.isCorrect);
    }

    _emitUpdatedState(
        currentState, correctAnswers, wrongAnswers, isRightListUpdated);
  }

  void checkUserAnswersOnly() {
    final currentState = _getCurrentState(state);
    if (currentState == null) return;

    int correctAnswers = currentState.correctAnswersCount;
    int wrongAnswers = currentState.wrongAnswersCount;
    List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isRightList);

    for (int i = 0; i < currentState.questions.length; i++) {
      // Skip if no answer or already evaluated
      if (currentState.userAnswers[i] == null || updatedIsCorrect[i] != null) {
        continue;
      }

      final result = _evaluateAnswer(
          currentState.questions[i], currentState.userAnswers[i]);

      if (result.hasAnswer) {
        updatedIsCorrect[i] = result.isCorrect;
        result.isCorrect ? correctAnswers++ : wrongAnswers++;
        _updateQuestionStatus(currentState.questions[i].id, result.isCorrect);

        _updateQuestionCorrectedUsecase.call(UpdateQuestionCorrectedParams(
          questionId: currentState.questions[i].id,
          isCorrected: true,
        ));

        _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
          questionId: currentState.questions[i].id,
          isAnswered: true,
          userAnswer: currentState.userAnswers[i],
        ));

        _updateQuestionAnsweredCorrectlyUsecase
            .call(UpdateQuestionAnsweredCorrectlyParams(
          questionId: currentState.questions[i].id,
          isAnsweredCorrectly: result.isCorrect,
        ));
      }
    }

    _emitUpdatedState(
        currentState, correctAnswers, wrongAnswers, updatedIsCorrect);
  }

  void checkMultipleChoiceAnswer(int index) {
    final currentState = _getCurrentState(state);
    if (currentState == null) return;

    // Set answer if not provided
    if (currentState.userAnswers[index] == null) {
      currentState.userAnswers[index] =
          currentState.questions[index].adjustedRightChoice;
    }

    final result = _evaluateAnswer(
        currentState.questions[index], currentState.userAnswers[index]);

    _updateQuestionCorrectedUsecase.call(UpdateQuestionCorrectedParams(
      questionId: currentState.questions[index].id,
      isCorrected: true,
    ));

    _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
      questionId: currentState.questions[index].id,
      isAnswered: true,
      userAnswer: currentState.userAnswers[index],
    ));

    _updateQuestionAnsweredCorrectlyUsecase
        .call(UpdateQuestionAnsweredCorrectlyParams(
      questionId: currentState.questions[index].id,
      isAnsweredCorrectly: result.isCorrect,
    ));

    List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isRightList);
    updatedIsCorrect[index] = result.isCorrect;

    final scoreUpdate = _updateScores(
      currentCorrect: currentState.correctAnswersCount,
      currentWrong: currentState.wrongAnswersCount,
      wasCorrect: currentState.isRightList[index] ?? false,
      isCorrect: result.isCorrect,
      hadAnswer: currentState.isRightList[index] != null,
    );

    _updateQuestionStatus(currentState.questions[index].id, result.isCorrect);
    _emitUpdatedState(currentState, scoreUpdate.correctAnswers,
        scoreUpdate.wrongAnswers, updatedIsCorrect);
  }

  void checkWrittenAnswer(int index, bool isCorrect) {
    final currentState = _getCurrentState(state);
    if (currentState == null) return;

    List<int?> updatedUserAnswers = List<int?>.from(currentState.userAnswers);
    List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isRightList);

    final hadAnswer = updatedUserAnswers[index] != null;
    final wasCorrect = updatedIsCorrect[index] ?? false;
    log("hadAnswer: $hadAnswer, wasCorrect: ${updatedIsCorrect[index] ?? "null"}, isCorrect: $isCorrect");

    // Only update if answer changed or is new
    if (!hadAnswer || wasCorrect != isCorrect) {
      updatedUserAnswers[index] = isCorrect ? 1 : 0; // Mark as answered
      updatedIsCorrect[index] = isCorrect;

      _updateQuestionCorrectedUsecase.call(UpdateQuestionCorrectedParams(
        questionId: currentState.questions[index].id,
        isCorrected: true,
      ));

      _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
        questionId: currentState.questions[index].id,
        isAnswered: true,
        userAnswer: isCorrect ? 1 : 0,
      ));

      _updateQuestionAnsweredCorrectlyUsecase
          .call(UpdateQuestionAnsweredCorrectlyParams(
        questionId: currentState.questions[index].id,
        isAnsweredCorrectly: isCorrect,
      ));

      final scoreUpdate = _updateScores(
        currentCorrect: currentState.correctAnswersCount,
        currentWrong: currentState.wrongAnswersCount,
        wasCorrect: wasCorrect,
        isCorrect: isCorrect,
        hadAnswer: hadAnswer,
      );

      _updateQuestionStatus(currentState.questions[index].id, isCorrect);

      emit(
        currentState.copyWith(
          correctAnswers: scoreUpdate.correctAnswers,
          wrongAnswers: scoreUpdate.wrongAnswers,
          userAnswers: updatedUserAnswers,
          isCorrect: updatedIsCorrect,
        ),
      );
    }
  }

  // Helper methods
  void _updateQuestionStatus(int questionId, bool isCorrect) {
    toggleQuestionIncorrectAnswer(
        questionId: questionId, answerStatus: isCorrect);
  }

  void _emitUpdatedState(
    QuestionSuccess currentState,
    int correctAnswers,
    int wrongAnswers,
    List<bool?> isCorrect,
  ) {
    emit(
      currentState.copyWith(
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        isCorrect: isCorrect,
      ),
    );
  }

  Future<Either<Failure, Uint8List?>> _getQuestionPhoto(
      int questionId, String questionUrl) async {
    if (state is QuestionSuccess) {
      QuestionPhotoParams params =
          QuestionPhotoParams(questionId: questionId, questionUrl: questionUrl);
      final result = await _getQuestionPhotoUseCase.call(params);
      log("done ===========================================");
      return result;
    }
    return Left(Failure(errMessage: ""));
  }

  Future<void> getQuestionHintPhoto(
      int questionId, String questionHintUrl) async {
    if (state is QuestionSuccess) {
      final currentState = state as QuestionSuccess;
      QuestionPhotoParams params = QuestionPhotoParams(
          questionId: questionId, questionUrl: questionHintUrl);
      final result = await _getQuestionHintPhotoUseCase.call(params);

      result.fold(
        (failure) {},
        (photo) => emit(currentState.copyWith(
          questions: currentState.questions
              .map((question) => question.id == questionId
                  ? question.copyWith(downloadedHintPhoto: photo)
                  : question)
              .toList(),
        )),
      );
    }
  }

  void toggleExpandedImage(int index) async {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      Map<int, bool> updatedExpandedImages =
          Map<int, bool>.from(currentState.expandedImages);
      updatedExpandedImages[index] = !(updatedExpandedImages[index] ?? false);
      emit(
        currentState.copyWith(
          expandedImages: updatedExpandedImages,
        ),
      );
      if (currentState.questions[index].downloadedQuestionPhoto == null) {
        if (currentState.questions[index].questionPhoto != null) {
          final response = await _getQuestionPhoto(
              currentState.questions[index].id,
              currentState.questions[index].questionPhoto!);
          response.fold(
            (failure) {},
            (photo) => emit(currentState.copyWith(
              expandedImages: updatedExpandedImages,
              questions: currentState.questions
                  .map((question) =>
                      question.id == currentState.questions[index].id
                          ? question.copyWith(downloadedQuestionPhoto: photo)
                          : question)
                  .toList(),
            )),
          );
          return;
        }
      }
    }
  }

  void toggleExpandedAnswer(int index) {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      Map<int, bool> updatedExpandedAnswers =
          Map<int, bool>.from(currentState.expandedAnswers);

      updatedExpandedAnswers[index] = !(updatedExpandedAnswers[index] ?? false);

      emit(
        currentState.copyWith(
          expandedAnswers: updatedExpandedAnswers,
        ),
      );
    }
  }

  Future<void> getEditedQuestionsByLesson({
    required int lessonId,
    required int? typeId,
  }) async {
    emit(QuestionLoading());
    EditedQuestionsByLessonParams params = EditedQuestionsByLessonParams(
      lessonId: lessonId,
      typeId: typeId,
    );
    final result = await _getEditedQuestionsByLessonUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      _initializeControllers,
    );
  }

  Future<void> getFavoriteGroupsQuestions({
    required int lessonId,
    required int? typeId,
  }) async {
    emit(QuestionLoading());
    FavoriteGroupsQuestionsParams params = FavoriteGroupsQuestionsParams(
      lessonId: lessonId,
      typeId: typeId,
    );
    final result = await _getFavQuestionsByLessonUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      _initializeControllers,
    );
  }

  Future<void> getIncorrectAnswerGroupsQuestions({
    required int lessonId,
    required int? typeId,
  }) async {
    emit(QuestionLoading());
    IncorrectAnswerGroupsQuestionsParams params =
        IncorrectAnswerGroupsQuestionsParams(
      lessonId: lessonId,
      typeId: typeId,
    );
    final result = await _getIncorrectQuestionsByLessonUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      _initializeControllers,
    );
  }

  Future<void> saveQuestionNote({
    required int questionId,
    required String note,
  }) async {
    SaveQuestionNoteParams params = SaveQuestionNoteParams(
      questionId: questionId,
      note: note,
    );
    final result = await _saveQuestionNoteUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      (success) {
        if (state is QuestionSuccess) {
          final currentState = state as QuestionSuccess;
          emit(currentState);
          emit(QuestionSuccess(
            questions: currentState.questions
                .map((question) => question.id == questionId
                    ? question.copyWith(note: note)
                    : question)
                .toList(),
            correctAnswersCount: currentState.correctAnswersCount,
            wrongAnswersCount: currentState.wrongAnswersCount,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isRightList: currentState.isRightList,
            expandedImages: currentState.expandedImages,
            expandedAnswers: currentState.expandedAnswers,
          ));
        }
      },
    );
  }

  Future<void> toggleQuestionFavorite({
    required int questionId,
    required bool isFavorite,
  }) async {
    log("isFavorite: $isFavorite");
    if (state is! QuestionSuccess) return;
    final currentState = state as QuestionSuccess;

    // Find the question group ID for the given question
    final question =
        currentState.questions.firstWhere((q) => q.id == questionId);
    final questionGroupId = question.questionGroupId;

    ToggleQuestionFavoriteParams params = ToggleQuestionFavoriteParams(
      questionId: questionId,
      isFavorite: isFavorite,
    );
    final result = await _toggleQuestionFavoriteUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      (success) {
        if (state is QuestionSuccess) {
          final currentState = state as QuestionSuccess;
          emit(currentState);
          emit(QuestionSuccess(
            questions: currentState.questions
                .map((question) => question.questionGroupId == questionGroupId
                    ? question.copyWith(isFavorite: isFavorite)
                    : question)
                .toList(),
            correctAnswersCount: currentState.correctAnswersCount,
            wrongAnswersCount: currentState.wrongAnswersCount,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isRightList: currentState.isRightList,
            expandedImages: currentState.expandedImages,
            expandedAnswers: currentState.expandedAnswers,
          ));
        }
      },
    );
  }

  Future<void> toggleQuestionIncorrectAnswer({
    required int questionId,
    required bool answerStatus,
  }) async {
    ToggleQuestionIncorrectAnswerParams params =
        ToggleQuestionIncorrectAnswerParams(
      questionId: questionId,
      answerStatus: answerStatus,
    );
    final result = await _toggleQuestionCorrectUseCase.call(params);
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      (success) {
        if (state is QuestionSuccess) {
          final currentState = state as QuestionSuccess;
          emit(currentState);
          emit(QuestionSuccess(
            questions: currentState.questions,
            correctAnswersCount: currentState.correctAnswersCount,
            wrongAnswersCount: currentState.wrongAnswersCount,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isRightList: currentState.isRightList,
            expandedImages: currentState.expandedImages,
            expandedAnswers: currentState.expandedAnswers,
          ));
        }
      },
    );
  }

  Future<void> startQuiz({
    required QuestionFromQuizArg arg,
  }) async {
    emit(QuestionLoading());
    final result = await _getQuizQuestionsUseCase.call(QuizFilterParams(
      subjectId: arg.subjectId,
      lessonIds: arg.lessonIds,
      typeIds: arg.typeIds,
      tagIds: arg.tagIds,
    ));
    // log("result: $result");
    _shuffleQuestions(result, arg.questionCount);

    // _initializeControllers(result);
  }

  void _shuffleQuestions(List<QuestionEntity> result, int questionCount) {
    log("result in shuffle questions method: $result");
    Set<int> groupIds = {};
    Map<int, List<QuestionEntity>> groupedQuestions = {};
    int currentQuestionCount = 0;
    for (var question in result) {
      log("question group id: ${question.questionGroupId}");
      //? add the group id to the set
      groupIds.add(question.questionGroupId!);
      //? add each question to the list of questions in the same group
      groupedQuestions[question.questionGroupId!] = [
        ...groupedQuestions[question.questionGroupId!] ?? [],
        question
      ];
    }
    log("groupedQuestions: $groupedQuestions");
    log("groupIds: $groupIds");

    //? shuffle the group ids
    List<int> shuffledGroupIds = groupIds.toList()..shuffle();

    List<QuestionEntity> shuffledQuestions = [];
    for (int groupId in shuffledGroupIds) {
      shuffledQuestions.addAll(groupedQuestions[groupId]!);
      currentQuestionCount += groupedQuestions[groupId]!.length;
      if (currentQuestionCount >= questionCount) {
        break;
      }
    }
    _initializeControllers(shuffledQuestions);
  }

  Future<void> updateQuestionAnswered(
      {required int index, required int answerIndex}) async {
    final currentState = _getCurrentState(state);
    if (currentState == null) return;

    // Create a new list and then modify it
    final updatedAnswers = [...currentState.userAnswers];
    updatedAnswers[index] = answerIndex;

    final result =
        await _updateQuestionAnsweredUsecase.call(UpdateQuestionAnsweredParams(
      questionId: currentState.questions[index].id,
      isAnswered: true,
      userAnswer: answerIndex,
    ));

    emit(currentState.copyWith(userAnswers: updatedAnswers));
  }

  @override
  Future<void> close() async {
    // enableScreenshot();
    noteController.dispose();
    noteFocusNode.dispose();
    timer?.cancel();
    return super.close();
  }
}

// Helper classes for better type safety and clarity
class AnswerResult {
  final bool isCorrect;
  final bool hasAnswer;

  AnswerResult({required this.isCorrect, required this.hasAnswer});
}

class ScoreUpdate {
  final int correctAnswers;
  final int wrongAnswers;

  ScoreUpdate({required this.correctAnswers, required this.wrongAnswers});
}
