import 'package:flutter/material.dart';

import 'widgets/company_description.dart';
import 'widgets/company_logo.dart';
import 'widgets/company_title.dart';
import 'widgets/contact_info.dart';
import 'widgets/socail_meida_section.dart';

class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl, // Right to left for Arabic
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CompanyLogo(),
                  SizedBox(height: 32),
                  CompanyTitle(),
                  SizedBox(height: 24),
                  CompanyDescription(),
                  SizedBox(height: 40),
                  SocialMediaSection(),
                  SizedBox(height: 48),
                  ContactInformation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
