part of "../questions_screen.dart";

class ResetAnswersButton extends StatelessWidget {
  const ResetAnswersButton({super.key, required this.subjectColor});

  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedRaisedButtonWithChild(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.circular(16),
      onPressed:
          () => _QuestionsScreenDialogManager._showConfirmationDialog(
            true,
            'إعادة تعيين الإجابات',
            context.read<QuestionCubit>().resetAnswers,
            context,
            subjectColor,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.refresh, color: Colors.white),
          const SizedBox(width: 8),
          const Text('إعادة تعيين', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
