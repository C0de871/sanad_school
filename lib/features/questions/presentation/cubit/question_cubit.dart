import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/use_cases/get_questions_in_lesson_by_type_use_case.dart';
import '../../domain/use_cases/get_questions_in_subject_by_tag.dart';
import '../questions_screen.dart';
import 'question_state.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetQuestionsInLessonByTypeUseCase getLessonQuestionsByTypeUseCase;
  final GetQuestionsInSubjectByTagUseCase getQuestionsInSubjectByTagUseCase;
  Timer? timer;
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  List<Map<String, dynamic>> questionsController = [];
  List<Map<String, dynamic>> questionsScrollController = [];
  List<Map<String, dynamic>> questionsFocusNode = [];
  static String questionControllersNodeKey = "question-controller";
  static String answersControllerNodeKey = "answers-controller";

  QuestionCubit()
      : getLessonQuestionsByTypeUseCase = getIt(),
        getQuestionsInSubjectByTagUseCase = getIt(),
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

  QuillController getAnswerController(int questionIndex, int answerIndex) {
    return questionsController[questionIndex][answersControllerNodeKey][answerIndex];
  }

  FocusNode getAnswerFocusNode(int questionIndex, int answerIndex) {
    return questionsFocusNode[questionIndex][answersControllerNodeKey][answerIndex];
  }

  ScrollController getAnswerScrollController(int questionIndex, int answerIndex) {
    return questionsScrollController[questionIndex][answersControllerNodeKey][answerIndex];
  }

  Future<void> getQuestionsByLessonAndType({
    required int lessonId,
    required int typeId,
  }) async {
    emit(QuestionLoading());
    QuestionsInLessonWithTypeParams params = QuestionsInLessonWithTypeParams(lessonId: lessonId, typeId: typeId);
    final result = await getLessonQuestionsByTypeUseCase.call(
      params: params,
    );
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      (questions) {
        questionsController = List.generate(questions.length, (questionIndex) {
          return {
            questionControllersNodeKey: QuillController(
              document: Document.fromJson(questions[questionIndex].textQuestion),
              selection: const TextSelection.collapsed(offset: 0),
              readOnly: true,
            ),
            answersControllerNodeKey: List.generate(
              questions[questionIndex].choices.length,
              (choiceIndex) {
                return QuillController(
                  document: Document.fromJson(questions[questionIndex].choices[choiceIndex]),
                  selection: const TextSelection.collapsed(offset: 0),
                  readOnly: true,
                );
              },
            ),
          };
        });
        questionsScrollController = List.generate(questions.length, (index) {
          return {
            questionControllersNodeKey: ScrollController(),
            answersControllerNodeKey: List.filled(questions[index].choices.length, ScrollController()),
          };
        });
        questionsFocusNode = List.generate(questions.length, (index) {
          return {
            questionControllersNodeKey: FocusNode(),
            answersControllerNodeKey: List.filled(questions[index].choices.length, FocusNode()),
          };
        });
        emit(QuestionSuccess(
          questions: questions,
          userAnswers: List.generate(questions.length, (index) => null),
          isCorrect: List.generate(questions.length, (index) => null),
        ));
      },
    );
  }

  Future<void> getSubjectQuestionsByTag({
    required int tagId,
  }) async {
    emit(QuestionLoading());
    QuestionsInSubjectByTag params = QuestionsInSubjectByTag(tagId: tagId);
    final result = await getQuestionsInSubjectByTagUseCase.call(
      params: params,
    );
    result.fold(
      (failure) => emit(QuestionFailure(failure.errMessage)),
      (questions) {
        questionsController = List.generate(questions.length, (questionIndex) {
          return {
            questionControllersNodeKey: QuillController(
              document: Document.fromJson(questions[questionIndex].textQuestion),
              selection: const TextSelection.collapsed(offset: 0),
              readOnly: true,
            ),
            answersControllerNodeKey: List.generate(
              questions[questionIndex].choices.length,
              (choiceIndex) {
                return QuillController(
                  document: Document.fromJson(questions[questionIndex].choices[choiceIndex]),
                  selection: const TextSelection.collapsed(offset: 0),
                  readOnly: true,
                );
              },
            ),
          };
        });
        questionsScrollController = List.generate(questions.length, (index) {
          return {
            questionControllersNodeKey: ScrollController(),
            answersControllerNodeKey: List.filled(questions[index].choices.length, ScrollController()),
          };
        });
        questionsFocusNode = List.generate(questions.length, (index) {
          return {
            questionControllersNodeKey: FocusNode(),
            answersControllerNodeKey: List.filled(questions[index].choices.length, FocusNode()),
          };
        });
        emit(QuestionSuccess(
          questions: questions,
          userAnswers: List.generate(questions.length, (index) => null),
          isCorrect: List.generate(questions.length, (index) => null),
        ));
      },
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
        if (currentState.questions[i].type == QuestionType.multipleChoice) {
          if (currentState.userAnswers[i] == null) {
            updatedIsCorrect[i] = false;
            wrongAnswers++;
          } else {
            if (currentState.userAnswers[i] == currentState.questions[i].rightChoice) {
              correctAnswers++;
              updatedIsCorrect[i] = true;
            } else {
              wrongAnswers++;
              updatedIsCorrect[i] = false;
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
        if (currentState.questions[i].type == QuestionType.multipleChoice) {
          if (currentState.userAnswers[i] == null || updatedIsCorrect[i] != null) {
            continue;
          } else {
            if (currentState.userAnswers[i] == currentState.questions[i].rightChoice) {
              correctAnswers++;
              updatedIsCorrect[i] = true;
            } else {
              wrongAnswers++;
              updatedIsCorrect[i] = false;
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
        return;
      }

      int correctAnswers = currentState.correctAnswers;
      int wrongAnswers = currentState.wrongAnswers;
      List<bool?> updatedIsCorrect = List<bool?>.from(currentState.isCorrect);

      if (currentState.userAnswers[index] == currentState.questions[index].rightChoice) {
        updatedIsCorrect[index] = true;
        correctAnswers++;
      } else {
        updatedIsCorrect[index] = false;
        wrongAnswers++;
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
      } else if (updatedIsCorrect[index] != isCorrect) {
        updatedUserAnswers[index] = 0;
        updatedIsCorrect[index] = isCorrect;
        if (isCorrect) {
          correctAnswers++;
          wrongAnswers--;
        } else {
          wrongAnswers++;
          correctAnswers--;
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

  void toggleExpandedImage(int index) {
    final currentState = state;
    if (currentState is QuestionSuccess) {
      Map<int, bool> updatedExpandedImages = Map<int, bool>.from(currentState.expandedImages);

      updatedExpandedImages[index] = !(updatedExpandedImages[index] ?? false);

      emit(
        currentState.copyWith(
          expandedImages: updatedExpandedImages,
        ),
      );
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

  @override
  Future<void> close() async {
    noteController.dispose();
    noteFocusNode.dispose();
    timer?.cancel();
    return super.close();
  }
}
