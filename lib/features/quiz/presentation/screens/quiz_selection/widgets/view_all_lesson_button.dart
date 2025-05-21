import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../all_lesson/all_lesson_screen.dart';

// Complete the view all buttons functionality
class ViewAllLessonsButton extends StatelessWidget {
  const ViewAllLessonsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedRaisedButtonWithChild(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: const AllLessonsScreen(),
              ),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "عرض الكل",
              style: TextStyle(
                color: cubit.quizScreenArgs.subjectColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: cubit.quizScreenArgs.subjectColor,
            ),
          ],
        ),
      ),
    );
  }
}
