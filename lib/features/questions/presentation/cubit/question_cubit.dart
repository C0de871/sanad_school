import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../quiz/domain/usecases/get_quiz_questions.dart';
import '../../domain/usecases/get_question_hint_photo.dart';
import '../../domain/usecases/get_question_photo.dart';
import '../../domain/usecases/get_questions_in_lesson_by_type_use_case.dart';
import '../../domain/usecases/get_questions_in_subject_by_tag.dart';
import '../../domain/usecases/question_usecases.dart';
import '../arg/question_from_quiz_arg.dart';
import '../questions_screen.dart';
import 'question_state.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../domain/entities/question_entity.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetQuestionsInLessonByTypeUseCase _getLessonQuestionsByTypeUseCase;
  final GetQuestionsInSubjectByTagUseCase _getQuestionsInSubjectByTagUseCase;
  final GetEditedQuestionsByLessonUseCase _getEditedQuestionsByLessonUseCase;
  final GetIncorrectAnswerGroupsQuestionsUseCase _getIncorrectQuestionsByLessonUseCase;
  final GetFavoriteGroupsQuestionsUseCase _getFavQuestionsByLessonUseCase;
  final SaveQuestionNoteUseCase _saveQuestionNoteUseCase;
  final ToggleQuestionFavoriteUseCase _toggleQuestionFavoriteUseCase;
  final ToggleQuestionIncorrectAnswerUseCase _toggleQuestionCorrectUseCase;
  final GetQuestionPhoto _getQuestionPhotoUseCase;
  final GetQuestionHintPhoto _getQuestionHintPhotoUseCase;
  final GetQuizQuestionsUsecase _getQuizQuestionsUseCase;
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
        super(QuestionInitial());

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
    return questionsController[questionIndex][answersControllerNodeKey][answerIndex];
  }

  FocusNode getAnswerFocusNode(int questionIndex, int answerIndex) {
    return questionsFocusNode[questionIndex][answersControllerNodeKey][answerIndex];
  }

  ScrollController getAnswerScrollController(int questionIndex, int answerIndex) {
    return questionsScrollController[questionIndex][answersControllerNodeKey][answerIndex];
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
          document: (questions[questionIndex].hint == null || questions[questionIndex].hint!.isEmpty) ? Document() : Document.fromJson(questions[questionIndex].hint!),
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        ),
        answersControllerNodeKey: List.generate(
          questions[questionIndex].choices.length,
          (choiceIndex) => QuillController(
            document: Document.fromJson(questions[questionIndex].choices[choiceIndex]),
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
        answersControllerNodeKey: List.filled(questions[index].choices.length, ScrollController()),
      };
    });

    questionsFocusNode = List.generate(questions.length, (index) {
      return {
        questionControllersNodeKey: FocusNode(),
        hintControllersNodeKey: FocusNode(),
        answersControllerNodeKey: List.filled(questions[index].choices.length, FocusNode()),
      };
    });
    emit(QuestionSuccess(
      questions: questions,
      userAnswers: List.generate(questions.length, (index) => null),
      isCorrect: List.generate(questions.length, (index) => null),
    ));
  }

  Future<void> getQuestionsByLessonAndType({
    required int lessonId,
    required int? typeId,
  }) async {
    emit(QuestionLoading());
    QuestionsInLessonWithTypeParams params = QuestionsInLessonWithTypeParams(lessonId: lessonId, typeId: typeId);
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
    emit(currentState.copyWith(
      userAnswers: List.generate(currentState.questions.length, (index) => null),
      isCorrect: List.generate(currentState.questions.length, (index) => null),
      correctAnswers: 0,
      wrongAnswers: 0,
    ));
  }

  void checkAllAnswers() {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      int correctAnswers = 0;
      int wrongAnswers = 0;
      List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isCorrect);

      for (int i = 0; i < currentState.questions.length; i++) {
        if (currentState.questions[i].type == QuestionTypeEnum.multipleChoice) {
          if (currentState.userAnswers[i] == null) {
            updatedIsCorrect[i] = false;
            wrongAnswers++;
          } else {
            if (currentState.userAnswers[i] == currentState.questions[i].adjustedRightChoice) {
              correctAnswers++;
              updatedIsCorrect[i] = true;
              toggleQuestionIncorrectAnswer(questionId: currentState.questions[i].id, answerStatus: true);
            } else {
              wrongAnswers++;
              updatedIsCorrect[i] = false;
              toggleQuestionIncorrectAnswer(questionId: currentState.questions[i].id, answerStatus: false);
            }
          }
        } else {
          if (currentState.userAnswers[i] == null) {
            updatedIsCorrect[i] = false;
            wrongAnswers++;
          }
        }
      }

      emit(
        currentState.copyWith(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          isCorrect: updatedIsCorrect,
        ),
      );
    }
  }

  void checkUserAnswersOnly() {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      int correctAnswers = currentState.correctAnswers;
      int wrongAnswers = currentState.wrongAnswers;
      List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isCorrect);

      for (int i = 0; i < currentState.questions.length; i++) {
        if (currentState.questions[i].type == QuestionTypeEnum.multipleChoice) {
          if (currentState.userAnswers[i] == null || updatedIsCorrect[i] != null) {
            continue;
          } else {
            if (currentState.userAnswers[i] == currentState.questions[i].adjustedRightChoice) {
              correctAnswers++;
              updatedIsCorrect[i] = true;
              toggleQuestionIncorrectAnswer(questionId: currentState.questions[i].id, answerStatus: true);
            } else {
              wrongAnswers++;
              updatedIsCorrect[i] = false;
              toggleQuestionIncorrectAnswer(questionId: currentState.questions[i].id, answerStatus: false);
            }
          }
        }
      }

      emit(
        currentState.copyWith(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          isCorrect: updatedIsCorrect,
        ),
      );
    }
  }

  void checkMultipleChoiceAnswer(int index) {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      if (currentState.userAnswers[index] == null) {
        currentState.userAnswers[index] = currentState.questions[index].adjustedRightChoice;
      }

      int correctAnswers = currentState.correctAnswers;
      int wrongAnswers = currentState.wrongAnswers;
      List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isCorrect);

      if (currentState.userAnswers[index] == currentState.questions[index].adjustedRightChoice) {
        updatedIsCorrect[index] = true;
        correctAnswers++;
        toggleQuestionIncorrectAnswer(questionId: currentState.questions[index].id, answerStatus: true);
      } else {
        updatedIsCorrect[index] = false;
        wrongAnswers++;
        toggleQuestionIncorrectAnswer(questionId: currentState.questions[index].id, answerStatus: false);
      }

      emit(
        currentState.copyWith(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          isCorrect: updatedIsCorrect,
        ),
      );
    }
  }

  void checkWrittenAnswer(int index, bool isCorrect) {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      int correctAnswers = currentState.correctAnswers;
      int wrongAnswers = currentState.wrongAnswers;
      List<int?> updatedUserAnswers = List<int?>.from(currentState.userAnswers);
      List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isCorrect);

      if (updatedUserAnswers[index] == null) {
        updatedUserAnswers[index] = 0;
        updatedIsCorrect[index] = isCorrect;
        isCorrect ? correctAnswers++ : wrongAnswers++;
        toggleQuestionIncorrectAnswer(questionId: currentState.questions[index].id, answerStatus: isCorrect);
      } else if (updatedIsCorrect[index] != isCorrect) {
        updatedUserAnswers[index] = 0;
        updatedIsCorrect[index] = isCorrect;
        if (isCorrect) {
          correctAnswers++;
          wrongAnswers--;
          toggleQuestionIncorrectAnswer(questionId: currentState.questions[index].id, answerStatus: true);
        } else {
          wrongAnswers++;
          correctAnswers--;
          toggleQuestionIncorrectAnswer(questionId: currentState.questions[index].id, answerStatus: false);
        }
      }

      emit(
        currentState.copyWith(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          userAnswers: updatedUserAnswers,
          isCorrect: updatedIsCorrect,
        ),
      );
    }
  }

  Future<Either<Failure, Uint8List?>> _getQuestionPhoto(int questionId, String questionUrl) async {
    if (state is QuestionSuccess) {
      QuestionPhotoParams params = QuestionPhotoParams(questionId: questionId, questionUrl: questionUrl);
      final result = await _getQuestionPhotoUseCase.call(params);
      log("done ===========================================");
      return result;
    }
    return Left(Failure(errMessage: ""));
  }

  Future<void> getQuestionHintPhoto(int questionId, String questionHintUrl) async {
    if (state is QuestionSuccess) {
      final currentState = state as QuestionSuccess;
      QuestionPhotoParams params = QuestionPhotoParams(questionId: questionId, questionUrl: questionHintUrl);
      final result = await _getQuestionHintPhotoUseCase.call(params);

      result.fold(
        (failure) {},
        (photo) => emit(currentState.copyWith(
          questions: currentState.questions.map((question) => question.id == questionId ? question.copyWith(downloadedHintPhoto: photo) : question).toList(),
        )),
      );
    }
  }

  void toggleExpandedImage(int index) async {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      Map<int, bool> updatedExpandedImages = Map<int, bool>.from(currentState.expandedImages);
      updatedExpandedImages[index] = !(updatedExpandedImages[index] ?? false);
      emit(
        currentState.copyWith(
          expandedImages: updatedExpandedImages,
        ),
      );
      if (currentState.questions[index].downloadedQuestionPhoto == null) {
        if (currentState.questions[index].questionPhoto != null) {
          final response = await _getQuestionPhoto(currentState.questions[index].id, currentState.questions[index].questionPhoto!);
          response.fold(
            (failure) {},
            (photo) => emit(currentState.copyWith(
              expandedImages: updatedExpandedImages,
              questions: currentState.questions.map((question) => question.id == currentState.questions[index].id ? question.copyWith(downloadedQuestionPhoto: photo) : question).toList(),
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
      Map<int, bool> updatedExpandedAnswers = Map<int, bool>.from(currentState.expandedAnswers);

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
    IncorrectAnswerGroupsQuestionsParams params = IncorrectAnswerGroupsQuestionsParams(
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
            questions: currentState.questions.map((question) => question.id == questionId ? question.copyWith(note: note) : question).toList(),
            correctAnswers: currentState.correctAnswers,
            wrongAnswers: currentState.wrongAnswers,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isCorrect: currentState.isCorrect,
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
    final question = currentState.questions.firstWhere((q) => q.id == questionId);
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
            questions: currentState.questions.map((question) => question.questionGroupId == questionGroupId ? question.copyWith(isFavorite: isFavorite) : question).toList(),
            correctAnswers: currentState.correctAnswers,
            wrongAnswers: currentState.wrongAnswers,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isCorrect: currentState.isCorrect,
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
    ToggleQuestionIncorrectAnswerParams params = ToggleQuestionIncorrectAnswerParams(
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
            correctAnswers: currentState.correctAnswers,
            wrongAnswers: currentState.wrongAnswers,
            seconds: currentState.seconds,
            isTimerRunning: currentState.isTimerRunning,
            userAnswers: currentState.userAnswers,
            isCorrect: currentState.isCorrect,
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
      groupedQuestions[question.questionGroupId!] = [...groupedQuestions[question.questionGroupId!] ?? [], question];
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

  @override
  Future<void> close() async {
    noteController.dispose();
    noteFocusNode.dispose();
    timer?.cancel();
    return super.close();
  }
}
