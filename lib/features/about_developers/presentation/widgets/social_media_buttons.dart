import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../about_sanad/presentation/about_us_screen.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        SocialButton(
          icon: FontAwesomeIcons.facebook,
          onPressed: () {},
          backgroundColor: const Color(0xFF1877F2),
        ),
        SocialButton(
          icon: FontAwesomeIcons.instagram,
          onPressed: () {},
          backgroundColor: Color(0xFFE1306C),
        ),
        SocialButton(
          icon: FontAwesomeIcons.linkedin,
          onPressed: () {},
          backgroundColor: Color(0xFF0077B5),
        ),
        SocialButton(
          icon: FontAwesomeIcons.telegram,
          onPressed: () {},
          backgroundColor: Color(0xFF0088CC),
        ),
        SocialButton(
          icon: FontAwesomeIcons.whatsapp,
          onPressed: () {},
          backgroundColor: const Color(0xFF25D366),
        ),
      ],
    );
  }
}
