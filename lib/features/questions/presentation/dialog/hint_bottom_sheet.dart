part of "../questions_screen.dart";

class _HintBottomSheet extends StatelessWidget {
  const _HintBottomSheet({
    required this.questionIndex,
    required this.state,
    required this.subjectColor,
  });

  final int questionIndex;
  final QuestionSuccess state;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.extendedColorOf(context).answerCard,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Icon(Icons.lightbulb, color: subjectColor),
              const SizedBox(width: 12),
              Text(
                'Hint',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: subjectColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MyQuillEditor(
            focusNode: questionCubit.getHintFocusNode(questionIndex),
            controller: questionCubit.getHintController(questionIndex),
            scrollController: questionCubit.getHintScrollController(
              questionIndex,
            ),
          ),
          const SizedBox(height: 16),
          if (state.questions[questionIndex].hintPhoto != null)
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                switch (state) {
                  case QuestionSuccess():
                    if (state.questions[questionIndex].downloadedHintPhoto !=
                        null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 350),
                          child: Image.memory(
                            state.questions[questionIndex].downloadedHintPhoto!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (state.questions[questionIndex].hintPhoto !=
                        null) {
                      return Center(
                        child: CoolLoadingScreen(
                          primaryColor: subjectColor,
                          secondaryColor: subjectColor.withAlpha(100),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  case QuestionInitial():
                    return const SizedBox();
                  case QuestionLoading():
                    return Center(
                      child: CoolLoadingScreen(
                        primaryColor: subjectColor,
                        secondaryColor: subjectColor.withAlpha(100),
                      ),
                    );
                  case QuestionFailure():
                    return const SizedBox();
                }
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
