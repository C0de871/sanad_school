import 'package:flutter/material.dart';

import 'contact_info_row.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.indigo.shade50,
      ),
      child: Column(
        children: [
          ContactInfoRow(
            icon: Icons.email_outlined,
            text: "contact@timeofcode.com",
          ),
          const SizedBox(height: 12),
          ContactInfoRow(
            icon: Icons.location_on_outlined,
            text: "دمشق, الجمهورية العربية السورية",
          ),
        ],
      ),
    );
  }
}
