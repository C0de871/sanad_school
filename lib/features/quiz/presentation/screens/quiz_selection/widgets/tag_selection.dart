import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/helper/extensions.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_state.dart';
import 'view_all_tags_button.dart';

class TagsSelectionWidget extends StatelessWidget {
  const TagsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
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
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: state.availableTags.take(15).map((tag) {
                  final isSelected = state.selectedTags.contains(tag.id);

                  return AnimatedRaisedButtonWithChild(
                    onPressed: () => cubit.toggleTag(tag.id),
                    backgroundColor: isSelected
                        ? cubit.quizScreenArgs.subjectColor
                        : Theme.of(context).colorScheme.surfaceVariant,
                    shadowColor: isSelected
                        ? (null)
                        : (Theme.of(context).brightness.isDark
                            ? Colors.blueGrey.withAlpha(70)
                            : null),
                    shadowOffset: 5,
                    lerpValue: 0.1,
                    borderWidth: 1.5,
                    borderRadius: BorderRadius.circular(16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            ViewAllTagsButton(),
          ],
        );
      },
    );
  }
}
