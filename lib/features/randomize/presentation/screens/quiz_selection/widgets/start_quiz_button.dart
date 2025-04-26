import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_stata.dart';

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
                  final cubit = context.read<QuizSelectionCubit>();
                  final questions = await cubit.startQuiz();
                  if (questions.isNotEmpty) {
                    // Navigate to quiz screen with questions
                    //todo: navigate to quiz screen
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => QuizScreen(questions: questions),
                    //   ),
                    // );
                  }
                }
              : null,
          isDisable: !isEnabled,
          width: double.infinity,
          height: 60,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
          borderRadius: BorderRadius.circular(16),
          child: state.isLoading
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
