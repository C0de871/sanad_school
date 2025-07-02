part of "../questions_screen.dart";


class _NoteBottomSheet extends StatelessWidget {
  const _NoteBottomSheet({
    required this.subjectColor,
    required this.questionIndex,
    required this.question,
  });
  final Color subjectColor;
  final int questionIndex;
  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.extendedColorOf(context).answerCard,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note_add, color: subjectColor),
                      const SizedBox(width: 12),
                      Text(
                        'ملاحظات السؤال ${questionIndex + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: subjectColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: subjectColor.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: questionCubit.noteController,
                      focusNode: questionCubit.noteFocusNode,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'أضف ملاحظاتك هنا...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: subjectColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ الملاحظة'),
                          onPressed: () {
                            if (questionCubit.noteController.text
                                .trim()
                                .isNotEmpty) {
                              questionCubit.saveQuestionNote(
                                questionId: question.id,
                                note: questionCubit.noteController.text.trim(),
                              );
                            } else {
                              questionCubit.saveQuestionNote(
                                questionId: question.id,
                                note: '',
                              );
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      if (question.note != null &&
                          question.note!.trim().isNotEmpty) ...[
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            questionCubit.saveQuestionNote(
                              questionId: question.id,
                              note: '',
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
