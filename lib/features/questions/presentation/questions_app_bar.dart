part of "questions_screen.dart";

class _QuestionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String lessonName;

  const _QuestionAppBar({required this.lessonName});

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();

    return AppBar(
      title: Text(lessonName),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: Container(
          padding: EdgeInsets.only(bottom: padding4 * 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: BlocBuilder<QuestionCubit, QuestionState>(
            builder: (context, state) {
              return switch (state) {
                QuestionSuccess() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StateCard(
                      title: 'Total Questions',
                      value: state.questions.length.toString(),
                      icon: Icons.quiz,
                      color: Color(0xFF84D6FD),
                    ),
                    _StateCard(
                      title: 'Correct',
                      value: state.correctAnswersCount.toString(),
                      icon: Icons.check_circle,
                      color: Color.fromARGB(255, 121, 193, 69),
                    ),
                    _StateCard(
                      title: 'Wrong',
                      value: state.wrongAnswersCount.toString(),
                      icon: Icons.cancel,
                      color: Color.fromARGB(255, 254, 117, 117),
                    ),
                  ],
                ),
                _ => SizedBox(),
              };
            },
          ),
        ),
      ),
      actions: [TimerButton(questionCubit: questionCubit), TimerDisplay()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 58);
}
