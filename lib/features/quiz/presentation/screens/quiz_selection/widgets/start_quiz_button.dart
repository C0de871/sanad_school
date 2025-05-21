import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/Routes/app_routes.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../../../questions/presentation/arg/question_from_quiz_arg.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_state.dart';

class StartQuizButton extends StatelessWidget {
  const StartQuizButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        final isEnabled = state.availableQuestionCount >= state.requestedQuestionCount && state.requestedQuestionCount > 0 && (state.selectedLessons.isNotEmpty || state.selectedTags.isNotEmpty || state.selectedTypes.isNotEmpty);

        return AnimatedRaisedButtonWithChild(
          onPressed: isEnabled
              ? () async {
                  // final cubit = context.read<QuizSelectionCubit>();
                  // final questions = await cubit.startQuiz();
                  // if (questions.isNotEmpty) {
                  // Navigate to quiz screen with questions
                  //todo: navigate to quiz screen
                  Navigator.pushNamed(
                    context,
                    AppRoutes.questionsFromQuiz,
                    arguments: QuestionFromQuizArg(
                      textDirection: context.read<QuizSelectionCubit>().quizScreenArgs.textDirection,
                      subjectColor: context.read<QuizSelectionCubit>().quizScreenArgs.subjectColor,
                      subjectId: context.read<QuizSelectionCubit>().quizScreenArgs.subjectId,
                      lessonIds: state.selectedLessons,
                      tagIds: state.selectedTags,
                      typeIds: state.selectedTypes,
                      questionCount: state.requestedQuestionCount,
                    ),
                  );
                  // }
                }
              : null,
          isDisable: !isEnabled,
          width: double.infinity,
          height: 60,
          backgroundColor: context.read<QuizSelectionCubit>().quizScreenArgs.subjectColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: null,
          borderRadius: BorderRadius.circular(16),
          child: state.availableLessonsStatus == QuizSelectionStatus.loading || state.availableTagsStatus == QuizSelectionStatus.loading || state.availableTypesStatus == QuizSelectionStatus.loading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ابدأ الاختبار",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.play_arrow,
                      size: 24,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
