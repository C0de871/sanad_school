// AllLessonsScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../cubits/quiz_selection_cubit.dart';
import '../../cubits/quiz_selection_state.dart';

class AllLessonsScreen extends StatelessWidget {
  const AllLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("جميع الدروس"),
          backgroundColor: cubit.quizScreenArgs.subjectColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.availableLessons.length,
              itemBuilder: (context, index) {
                final lesson = state.availableLessons[index];
                final isSelected = state.selectedLessons.contains(lesson.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedRaisedButtonWithChild(
                    onPressed: () => cubit.toggleLesson(lesson.id),
                    backgroundColor: isSelected ? cubit.quizScreenArgs.subjectColor : Theme.of(context).colorScheme.surfaceVariant,
                    shadowColor: isSelected ? (null) : (getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null),
                    shadowOffset: 5,
                    lerpValue: 0.1,
                    borderWidth: 1.5,
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, size: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
