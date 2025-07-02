part of '../questions_screen.dart';
class CheckAnswersButton extends StatelessWidget {
  const CheckAnswersButton({super.key, required this.subjectColor});

  final Color subjectColor;

  void onLongPress(BuildContext context) {
    _QuestionsScreenDialogManager._showConfirmationDialog(
      false,
      'التحقق من جميع الأسئلة',
      () {
        context.read<QuestionCubit>().checkAllAnswers();
        _QuestionsScreenDialogManager._showSuccessDialog(context);
      },
      context,
      subjectColor,
    );
  }

  void onPress(BuildContext context) {
    _QuestionsScreenDialogManager._showConfirmationDialog(
      false,
      'التحقق من إجاباتك',
      () {
        context.read<QuestionCubit>().checkUserAnswersOnly();
        _QuestionsScreenDialogManager._showSuccessDialog(context);
      },
      context,
      subjectColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRaisedButtonWithChild(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: subjectColor,
      borderRadius: BorderRadius.circular(16),
      onLongPressed: () => onLongPress(context),
      onPressed: () => onPress(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          const Text('تحقق من الأسئلة', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
