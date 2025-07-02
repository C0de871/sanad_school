part of "../questions_screen.dart";

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.subjectColor});

  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: CheckAnswersButton(subjectColor: subjectColor)),
          const SizedBox(width: 16),
          Expanded(child: ResetAnswersButton(subjectColor: subjectColor)),
        ],
      ),
    );
  }
}
