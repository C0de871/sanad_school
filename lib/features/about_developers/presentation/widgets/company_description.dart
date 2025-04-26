import 'package:flutter/material.dart';

class CompanyDescription extends StatelessWidget {
  const CompanyDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Text(
        "شركة ناشئة في مجال البرمجة والتصميم، تقدم خدمات تصميم المواقع الالكترونية وتطبيقات الهاتف المحمول بالإضافة إلى خدمات التصميم والهوية البصرية والمونتاج",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }
}
