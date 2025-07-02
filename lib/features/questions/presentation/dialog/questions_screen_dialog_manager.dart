part of '../questions_screen.dart';

class _QuestionsScreenDialogManager {
  static void _showHintBottomSheet(
    BuildContext parentContext,
    int questionIndex,
    QuestionSuccess state,
    Color subjectColor,
  ) {
    final questionCubit = parentContext.read<QuestionCubit>();
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => BlocProvider.value(
            value: questionCubit,
            child: _HintBottomSheet(
              questionIndex: questionIndex,
              state: state,
              subjectColor: subjectColor,
            ),
          ),
    );
  }

  static void _showSuccessDialog(BuildContext parentContext) {
    showGeneralDialog(
      context: parentContext,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: parentContext.read<QuestionCubit>(),
          child: _QuestionsSuccessDialog(animation: animation),
        );
      },
    );
  }

  static Future<void> _showConfirmationDialog(
    bool isReset,
    String action,
    VoidCallback onConfirm,
    BuildContext context,
    Color subjectColor,
  ) async {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => _ConfirmDialog(
            action: action,
            onConfirm: onConfirm,
            isReset: isReset,
            subjectColor: subjectColor,
          ),
    );
  }

  static void _showNoteBottomSheet(
    BuildContext parentContext,
    int questionIndex,
    QuestionEntity question,
    String? note,
    Color subjectColor,
  ) {
    final questionCubit = parentContext.read<QuestionCubit>();
    questionCubit.noteController.text = note ?? '';

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider.value(
            value: questionCubit,
            child: _NoteBottomSheet(
              subjectColor: subjectColor,
              questionIndex: questionIndex,
              question: question,
            ),
          ),
    );
  }

  static void _showReportOptions(
    BuildContext context,
    QuestionEntity question,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return _ReportBottomSheet(question: question);
      },
    );
  }
}
