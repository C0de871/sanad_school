import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/randomize/presentation/screens/quiz_selection/widgets/view_all_lesson_button.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_stata.dart';

class LessonsSelectionWidget extends StatelessWidget {
  const LessonsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cubit.allLessons.length > 9 ? 9 : cubit.allLessons.length,
                itemBuilder: (context, index) {
                  final lesson = cubit.allLessons[index];
                  final isSelected = state.selectedLessons.contains(lesson);

                  return AnimatedRaisedButtonWithChild(
                    onPressed: () => cubit.toggleLesson(lesson),
                    backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant,
                    shadowColor: isSelected ? (getIt<AppTheme>().extendedColors.buttonShadow) : (getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null),
                    shadowOffset: 5,
                    lerpValue: 0.1,
                    borderWidth: 1.5,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        lesson,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ViewAllLessonsButton(),
          ],
        );
      },
    );
  }
}
