part of "questions_screen.dart";

class _QuestionBody extends StatelessWidget {
  const _QuestionBody({super.key, required this.subjectColor});

  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return switch (state) {
          QuestionSuccess() => Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.questions[index];
                        return _QuestoinCard(
                          subjectColor: subjectColor,
                          question: question,
                          questionIndex: index,
                          state: state,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 64),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomActionBar(subjectColor: subjectColor),
              ),
            ],
          ),
          _ => Center(
            child: CoolLoadingScreen(
              primaryColor: subjectColor,
              secondaryColor: subjectColor.withAlpha(100),
            ),
          ),
        };
      },
    );
  }
}
