import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../../../questions/presentation/questions_screen.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_stata.dart';

class QuestionTypesWidget extends StatelessWidget {
  const QuestionTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AnimatedRaisedButtonWithChild(
                onPressed: () => cubit.toggleQuestionType(QuestionType.multipleChoice),
                backgroundColor: state.selectedTypes.contains(QuestionType.multipleChoice) ? getIt<AppTheme>().extendedColors.gradientBlue : Theme.of(context).colorScheme.surfaceVariant,
                foregroundColor: state.selectedTypes.contains(QuestionType.multipleChoice) ? getIt<AppTheme>().extendedColors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                // shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "اختيار من متعدد",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedRaisedButtonWithChild(
                onPressed: () => cubit.toggleQuestionType(QuestionType.written),
                backgroundColor: state.selectedTypes.contains(QuestionType.written) ? getIt<AppTheme>().extendedColors.gradientPurple : Theme.of(context).colorScheme.surfaceVariant,
                foregroundColor: state.selectedTypes.contains(QuestionType.written) ? getIt<AppTheme>().extendedColors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                // shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "إجابة مكتوبة",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
