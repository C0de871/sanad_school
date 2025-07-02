part of "../questions_screen.dart";

class _ReportBottomSheet extends StatelessWidget {
  const _ReportBottomSheet({super.key, required this.question});

  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
            title: const Text('أبلغ عن السؤال عبر الواتساب'),
            onTap: () {
              Navigator.pop(context);
              _launchWhatsApp(question.uuid);
            },
          ),
          ListTile(
            leading: const Icon(Icons.telegram, color: Colors.blue),
            title: const Text('أبلغ عن السؤال عبر التليغرام'),
            onTap: () {
              Navigator.pop(context);
              _launchTelegram(question.uuid);
            },
          ),
        ],
      ),
    );
  }

  void _launchWhatsApp(String uuid) async {
    // Make sure the phone number includes country code and no special characters
    String formattedNumber = Constant.whatsappNumber;
    String message =
        "أريد أن أبلغ عن مشكلة في السؤال sanadaltaleb.com/q/$uuid/report";

    // Try direct WhatsApp app URI first
    final whatsappUri = Uri.parse(
      'whatsapp://send?phone=$formattedNumber&text=$message',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      // Fallback to web URL
      final webUri = Uri.parse('https://wa.me/$formattedNumber?text=$message');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp');
      }
    }
  }

  void _launchTelegram(String uuid) async {
    String message =
        "أريد أن أبلغ عن مشكلة في السؤال sanadaltaleb.com/q/$uuid/report";

    // // Try direct Telegram app URI first
    // final telegramUri = Uri.parse(
    //     'https://t.me/${Constant.telegramUsername}?start&text=$message');

    // Fallback to web URL
    final webUri = Uri.parse(
      'https://t.me/${Constant.telegramUsername}?start&text=$message',
    );
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch Telegram');
    }
  }
}
