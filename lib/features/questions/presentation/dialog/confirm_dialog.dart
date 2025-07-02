part of "../questions_screen.dart";

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.action,
    required this.onConfirm,
    required this.isReset,
    required this.subjectColor,
  });

  final String action;
  final VoidCallback onConfirm;
  final bool isReset;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(action, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text('هل أنت متأكد أنك تريد $action?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
        ),
        AnimatedRaisedButtonWithChild(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isReset ? Colors.red : subjectColor,
          borderRadius: BorderRadius.circular(10),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                isReset ? 'إعادة تعيين' : 'تحقق ',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
