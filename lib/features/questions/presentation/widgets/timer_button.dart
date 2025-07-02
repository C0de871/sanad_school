import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_cubit.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_state.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({super.key, required this.questionCubit});

  final QuestionCubit questionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return switch (state) {
          QuestionSuccess() => GestureDetector(
            onLongPress: () {
              questionCubit.resetTimer();
            },
            child: IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () {
                if (state.isTimerRunning) {
                  questionCubit.stopTimer();
                } else {
                  questionCubit.startTimer();
                }
              },
            ),
          ),
          _ => SizedBox(),
        };
      },
    );
  }
}
