import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../all_tag/all_tag_screen.dart';

class ViewAllTagsButton extends StatelessWidget {
  const ViewAllTagsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit =context.read<QuizSelectionCubit>();
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedRaisedButtonWithChild(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: const AllTagsScreen(),
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
              "عرض جميع الوسوم",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: cubit.quizScreenArgs.subjectColor,
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
