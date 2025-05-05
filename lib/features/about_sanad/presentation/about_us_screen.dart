import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/presentation/widgets/animated_raised_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'سند الطالب',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'من نحن',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'منصة سند الطالب هي منصة تعليمية رائدة تهدف إلى دعم الطلاب في مسيرتهم الأكاديمية وتوفير كل ما يحتاجونه للتفوق والنجاح.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'خدماتنا',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),
              ServiceCard(
                title: 'ملفات المواد الدراسية',
                description: 'مجموعة شاملة من الملفات والمراجع لجميع المواد الدراسية، منظمة بشكل سهل وواضح للفهم والمراجعة.',
                icon: Icons.folder_outlined,
              ),
              ServiceCard(
                title: 'دورات تعليمية',
                description: 'دورات مميزة يقدمها نخبة من المدرسين المتخصصين، تغطي جميع المواد الدراسية بأسلوب تفاعلي وممتع.',
                icon: Icons.school_outlined,
              ),
              ServiceCard(
                title: 'اختبارات تفاعلية',
                description: 'مجموعة متنوعة من الاختبارات والتمارين لكل مادة، تساعد الطالب على تقييم مستواه وتحسين أدائه.',
                icon: Icons.quiz_outlined,
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  'تواصل معنا',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SocialButton(
                      icon: FontAwesomeIcons.facebook,
                      onPressed: () => _launchURL('https://www.facebook.com/groups/749570869609518/'),
                      backgroundColor: const Color(0xFF1877F2), // Facebook brand blue
                      tooltip: 'فيسبوك سند الطالب',
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.whatsapp,
                      onPressed: () => _launchURL('https://wa.me/message/your_whatsapp_link'), // Add your WhatsApp link here
                      backgroundColor: const Color(0xFF25D366), // WhatsApp brand green
                      tooltip: 'واتساب',
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.instagram,
                      onPressed: () => _launchURL('https://www.instagram.com/sanad_educational_team'),
                      backgroundColor: const Color(0xFFE1306C), // Instagram brand pink
                      tooltip: 'انستغرام سند الطالب',
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.telegram,
                      onPressed: () => _launchURL('https://t.me/SanadAlTaleb_bot'),
                      backgroundColor: const Color(0xFF0088CC), // Telegram brand blue
                      tooltip: 'تلغرام سند الطالب',
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.youtube,
                      onPressed: () => _launchURL('https://youtube.com/@sanadteam-z8f'),
                      backgroundColor: const Color(0xFFFF0000), // YouTube brand red
                      tooltip: 'يوتيوب سند الطالب',
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String tooltip;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: AnimatedRaisedButtonWithChild(
        backgroundColor: backgroundColor,
        shadowOffset: 3,
        lerpValue: 0.2,
        borderWidth: 1.5,
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
