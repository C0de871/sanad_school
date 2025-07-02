part of "../questions_screen.dart";

class _QuestoinCard extends StatelessWidget {
  const _QuestoinCard({
    required this.subjectColor,
    required this.question,
    required this.questionIndex,
    required this.state,
  });

  final Color subjectColor;
  final QuestionEntity question;
  final int questionIndex;
  final QuestionSuccess state;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        // color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! question text widget:
              QuestionText(
                subjectColor: subjectColor,
                questionIndex: questionIndex,
              ),

              //! question photo or toggle photo widgets:
              if (question.questionPhoto != null) ...[
                const SizedBox(height: 16),

                //! show image button:
                ToggleImageButton(
                  subjectColor: subjectColor,
                  state: state,
                  questionIndex: questionIndex,
                ),

                //! image widget:
                if (state.expandedImages[questionIndex] == true) ...[
                  const SizedBox(height: 16),
                  QuestionImage(question: question, subjectColor: subjectColor),
                ],
              ],

              //! written question widget:
              if (question.type == QuestionTypeEnum.written) ...[
                const SizedBox(height: 32),
                ExpandedAnswerOrToggleAnswer(
                  questionIndex: questionIndex,
                  state: state,
                  subjectColor: subjectColor,
                ),
              ],

              //! multiple choice answers widget:
              const SizedBox(height: 20),
              if (question.type == QuestionTypeEnum.multipleChoice)
                _MultipleChoiceAnswers(
                  question: question,
                  questionIndex: questionIndex,
                  state: state,
                ),

              //! question action buttons like: hint, note, report, favorite...
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QuestionActionButtons(
                      state: state,
                      questionIndex: questionIndex,
                      subjectColor: subjectColor,
                      question: question,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionActionButtons extends StatelessWidget {
  const QuestionActionButtons({
    super.key,
    required this.state,
    required this.questionIndex,
    required this.subjectColor,
    required this.question,
  });

  final QuestionSuccess state;
  final int questionIndex;
  final Color subjectColor;
  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state.questions[questionIndex].hint != null ||
                state.questions[questionIndex].hintPhoto != null) ...[
              HintButtonOrNull(
                state: state,
                questionIndex: questionIndex,
                questionCubit: questionCubit,
                subjectColor: subjectColor,
              ),
              const SizedBox(width: 8),
            ],
            FavoriteButton(question: question),
            const SizedBox(width: 8),
            NoteButton(
              question: question,
              subjectColor: subjectColor,
              questionIndex: questionIndex,
            ),
            const SizedBox(width: 8),
            ReportButton(question: question),
            if (question.type == QuestionTypeEnum.multipleChoice) ...[
              const SizedBox(width: 8),
              _BottomActionButton(
                icon: Icons.check,
                color: Colors.green,
                onPressed:
                    () => context
                        .read<QuestionCubit>()
                        .checkMultipleChoiceAnswer(questionIndex),
              ),
            ] else ...[
              const SizedBox(width: 8),
              _BottomActionButton(
                icon: Icons.check,
                color: Colors.green,
                onPressed:
                    () => context.read<QuestionCubit>().checkWrittenAnswer(
                      questionIndex,
                      true,
                    ),
              ),
              const SizedBox(width: 8),
              _BottomActionButton(
                icon: Icons.close,
                color: Colors.red,
                onPressed:
                    () => context.read<QuestionCubit>().checkWrittenAnswer(
                      questionIndex,
                      false,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, required this.question});

  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return _BottomActionButton(
      icon: Icons.campaign_outlined,
      color: Colors.red,
      onPressed:
          () => _QuestionsScreenDialogManager._showReportOptions(
            context,
            question,
          ),
    );
  }
}

class NoteButton extends StatelessWidget {
  const NoteButton({
    super.key,
    required this.question,
    required this.subjectColor,
    required this.questionIndex,
  });

  final QuestionEntity question;
  final Color subjectColor;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return _BottomActionButton(
      icon:
          question.note != null && question.note!.trim().isNotEmpty
              ? Icons.note
              : Icons.note_add,
      color: subjectColor,
      onPressed:
          () => _QuestionsScreenDialogManager._showNoteBottomSheet(
            context,
            questionIndex,
            question,
            question.note,
            subjectColor,
          ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.question});

  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return _BottomActionButton(
      icon: question.isFavorite ? Icons.favorite : Icons.favorite_border,
      color: Colors.red,
      onPressed: () {
        context.read<QuestionCubit>().toggleQuestionFavorite(
          questionId: question.id,
          isFavorite: !question.isFavorite,
        );
      },
    );
  }
}

class HintButtonOrNull extends StatelessWidget {
  const HintButtonOrNull({
    super.key,
    required this.state,
    required this.questionIndex,
    required this.questionCubit,
    required this.subjectColor,
  });

  final QuestionSuccess state;
  final int questionIndex;
  final QuestionCubit questionCubit;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return _BottomActionButton(
      icon: Icons.lightbulb_outline,
      color: Color(0xFFFFB347),
      onPressed: () {
        if (state.questions[questionIndex].hintPhoto != null &&
            state.questions[questionIndex].downloadedHintPhoto == null) {
          questionCubit.getQuestionHintPhoto(
            state.questions[questionIndex].id,
            state.questions[questionIndex].hintPhoto!,
          );
        }
        _QuestionsScreenDialogManager._showHintBottomSheet(
          context,
          questionIndex,
          state,
          subjectColor,
        );
      },
    );
  }
}

class ExpandedAnswerOrToggleAnswer extends StatelessWidget {
  const ExpandedAnswerOrToggleAnswer({
    super.key,
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
    return GestureDetector(
      onTap: () {
        context.read<QuestionCubit>().toggleExpandedAnswer(questionIndex);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: AppTheme.extendedColorOf(context).answerCard,
          child: Padding(
            padding: EdgeInsets.all(padding4 * 4),
            child: Center(
              child:
                  state.expandedAnswers[questionIndex] == true
                      ? QuillEditor(
                        focusNode: questionCubit.getAnswerFocusNode(
                          questionIndex,
                          0,
                        ),
                        controller: questionCubit.getAnswerController(
                          questionIndex,
                          0,
                        ),
                        scrollController: questionCubit
                            .getAnswerScrollController(questionIndex, 0),
                        config: QuillEditorConfig(
                          customStyles: DefaultStyles(
                            color:
                                AppTheme.extendedColorOf(context).blueTextColor,
                            paragraph: DefaultTextBlockStyle(
                              TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              const HorizontalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              null,
                            ),
                            // You can also set for other text types
                            h1: DefaultTextBlockStyle(
                              TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              const HorizontalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              null,
                            ),
                          ),
                          scrollable: false,
                          showCursor: false,
                          autoFocus: false,
                          requestKeyboardFocusOnCheckListChanged: false,
                          padding: EdgeInsets.zero,
                          unknownEmbedBuilder: FallbackEmbedBuilder(),
                          embedBuilders: [FormulaEmbedBuilder()],
                        ),
                        // question.answers[0], //todo: here the quill editor go
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.expandedAnswers[questionIndex] == true
                                ? Icons.visibility_off
                                : Icons.question_answer_outlined,
                            color: subjectColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'عرض الاجابة',
                            style: TextStyle(color: subjectColor),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionImage extends StatelessWidget {
  const QuestionImage({
    super.key,
    required this.question,
    required this.subjectColor,
  });

  final QuestionEntity question;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            question.downloadedQuestionPhoto != null
                ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 350),
                  child: Image.memory(
                    question.downloadedQuestionPhoto!,
                    fit: BoxFit.contain,
                  ),
                )
                : Container(
                  width: double.infinity,
                  color: AppTheme.extendedColorOf(context).answerCard,
                  child: Center(
                    child: CoolLoadingScreen(
                      primaryColor: subjectColor,
                      secondaryColor: subjectColor.withAlpha(100),
                    ),
                  ),
                ),
      ),
    );
  }
}

class ToggleImageButton extends StatelessWidget {
  const ToggleImageButton({
    super.key,
    required this.subjectColor,
    required this.state,
    required this.questionIndex,
  });

  final Color subjectColor;
  final QuestionSuccess state;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: subjectColor.withOpacity(0.1),
          ),
          icon: Icon(
            state.expandedImages[questionIndex] == true
                ? Icons.visibility_off
                : Icons.image,
            color: subjectColor,
          ),
          onPressed: () {
            context.read<QuestionCubit>().toggleExpandedImage(questionIndex);
          },
        ),
      ],
    );
  }
}

class QuestionText extends StatelessWidget {
  const QuestionText({
    super.key,
    required this.subjectColor,
    required this.questionIndex,
  });

  final Color subjectColor;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: subjectColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${questionIndex + 1}',
              style: TextStyle(
                color: subjectColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MyQuillEditor(
            focusNode: questionCubit.getQuestionFocusNode(questionIndex),
            controller: questionCubit.getQuestionController(questionIndex),
            scrollController: questionCubit.getQuestionScrollController(
              questionIndex,
            ),
          ),
        ),
      ],
    );
  }
}
