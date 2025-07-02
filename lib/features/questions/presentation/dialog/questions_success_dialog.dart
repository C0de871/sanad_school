part of "../questions_screen.dart";


class _QuestionsSuccessDialog extends StatelessWidget {
  const _QuestionsSuccessDialog({required this.animation});

  final Animation<double> animation;

  @override

  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'أحسنت',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return switch (state) {
                  QuestionSuccess() => Column(
                    children: [
                      Text(
                        'لقد اجبت على',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${state.correctAnswersCount} اجابة صحيحة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'و ${state.wrongAnswersCount} اجابة خاطئة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'نسبة الاجابات الصحيحة ${(state.correctAnswersCount / state.questions.length * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
            const SizedBox(height: 24),
            AnimatedRaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'تم',
              backgroundColor: Theme.of(context).colorScheme.primary,
              shadowColor: AppTheme.extendedColorOf(context).buttonShadow,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
