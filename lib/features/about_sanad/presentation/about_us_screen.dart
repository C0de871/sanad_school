import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            'منصة سند الطالب',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    icon: FontAwesomeIcons.facebook,
                    onPressed: () {},
                    backgroundColor: Color(0xFF1877F2), // Facebook brand blue
                  ),
                  SizedBox(width: 24),
                  SocialButton(
                    icon: FontAwesomeIcons.whatsapp,
                    onPressed: () {},
                    backgroundColor: Color(0xFF25D366), // WhatsApp brand green
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ServiceCard({super.key, 
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

  const SocialButton({super.key, 
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRaisedButtonWithChild(
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
    );
  }
}
