import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/helper/extensions.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_state.dart';

class QuestionTypesWidget extends StatelessWidget {
  const QuestionTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        return SizedBox(
          height: 140,
          child: ListView.builder(
            // padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: state.availableTypes.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  AnimatedRaisedButtonWithChild(
                    onPressed: () => cubit
                        .toggleQuestionType(state.availableTypes[index].id!),
                    backgroundColor: state.selectedTypes
                            .contains(state.availableTypes[index].id)
                        ? cubit.quizScreenArgs.subjectColor
                        : Theme.of(context).colorScheme.surfaceVariant,
                    foregroundColor: state.selectedTypes
                            .contains(state.availableTypes[index].id)
                        ? null
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    // shadowColor: AppTheme.extendedColorOf(context).buttonShadow,
                    shadowColor: state.selectedTypes
                            .contains(state.availableTypes[index].id)
                        ? (null)
                        : (Theme.of(context).brightness.isDark
                            ? Colors.blueGrey.withAlpha(70)
                            : null),
                    borderRadius: BorderRadius.circular(12),
                    width: 120,
                    height: 120,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.abc,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Tooltip(
                          message: state.availableTypes[index].name,
                          child: Text(
                            state.availableTypes[index].name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
