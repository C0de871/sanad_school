part of "../questions_screen.dart";

class _MultipleChoiceAnswers extends StatelessWidget {
  const _MultipleChoiceAnswers({
    required this.question,
    required this.questionIndex,
    required this.state,
  });

  final QuestionEntity question;
  final int questionIndex;
  final QuestionSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          question.choices
              .asMap()
              .entries
              .map(
                (entry) => _AnswerChoice(
                  choiceIndex: entry.key,
                  question: question,
                  questionIndex: questionIndex,
                  state: state,
                ),
              )
              .toList(),
    );
  }
}

class _AnswerChoice extends StatelessWidget {
  const _AnswerChoice({
    required this.choiceIndex,
    required this.question,
    required this.questionIndex,
    required this.state,
  });

  final int choiceIndex;
  final QuestionEntity question;
  final int questionIndex;
  final QuestionSuccess state;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    final colors = _getAnswerChoiceColors(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedRaisedButtonWithChild(
        isDisable: _isQuestionCorrected,
        backgroundColor: colors.backgroundColor,
        shadowColor: colors.shadowColor,
        shadowOffset: 3,
        lerpValue: 0.1,
        borderWidth: 1.5,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        borderRadius: BorderRadius.circular(16),
        onPressed:
            _isQuestionCorrected ? null : () => _onAnswerPressed(questionCubit),
        child: Center(
          child: _buildQuillEditor(questionCubit, colors.textColor),
        ),
      ),
    );
  }

  bool get _isSelected => choiceIndex == state.userAnswers[questionIndex];

  bool get _isCorrect => choiceIndex == question.adjustedRightChoice;

  bool get _isQuestionCorrected => state.isRightList[questionIndex] != null;

  void _onAnswerPressed(QuestionCubit questionCubit) {
    questionCubit.updateQuestionAnswered(
      index: questionIndex,
      answerIndex: choiceIndex,
    );
  }

  _AnswerChoiceColors _getAnswerChoiceColors(BuildContext context) {
    final customColors = AppTheme.extendedColorOf(context);
    final defaultBackgroundColor =
        Theme.of(context).colorScheme.surfaceContainerLow;
    const defaultTextColor = Colors.blueGrey;
    final defaultShadowColor = Colors.blueGrey.withAlpha(70);

    if (_isQuestionCorrected) {
      if (_isCorrect) {
        return _AnswerChoiceColors(
          backgroundColor: customColors.greenBackgroundColor,
          textColor: customColors.greenTextColor,
          shadowColor: customColors.greenShadowColor,
        );
      } else if (_isSelected) {
        return _AnswerChoiceColors(
          backgroundColor: customColors.redBackgroundColor,
          textColor: customColors.redTextColor,
          shadowColor: customColors.redShadowColor,
        );
      }
    } else if (_isSelected) {
      return _AnswerChoiceColors(
        backgroundColor: customColors.blueBackgroundColor,
        textColor: customColors.blueTextColor,
        shadowColor: customColors.blueShadowColor,
      );
    }

    return _AnswerChoiceColors(
      backgroundColor: defaultBackgroundColor,
      textColor: defaultTextColor,
      shadowColor: defaultShadowColor,
    );
  }

  Widget _buildQuillEditor(QuestionCubit questionCubit, Color textColor) {
    return MyQuillEditor(
      focusNode: questionCubit.getAnswerFocusNode(questionIndex, choiceIndex),
      controller: questionCubit.getAnswerController(questionIndex, choiceIndex),
      scrollController: questionCubit.getAnswerScrollController(
        questionIndex,
        choiceIndex,
      ),
      textColor: textColor,
    );
  }
}

class _AnswerChoiceColors {
  const _AnswerChoiceColors({
    required this.backgroundColor,
    required this.textColor,
    required this.shadowColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
}
