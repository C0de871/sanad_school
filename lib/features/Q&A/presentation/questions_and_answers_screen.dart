import 'package:flutter/material.dart';
import 'package:sanad_school/core/helper/extensions.dart';

import '../../auth/presentation/widgets/animated_raised_button.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});
  final List<Map<String, String>> faqItems = [
    {
      'question': 'كيف يمكنني الاشتراك في المنصة؟',
      'answer':
          'يمكنك الاشتراك من خلال الضغط على زر "التسجيل" في الصفحة الرئيسية، ثم اختيار الباقة المناسبة لك وإتمام عملية الدفع.',
    },
    {
      'question': 'هل المحتوى متاح على مدار الساعة؟',
      'answer':
          'نعم، جميع المحتوى متاح للوصول 24/7، يمكنك الدراسة في أي وقت يناسبك.',
    },
    {
      'question': 'هل يمكنني تحميل الملفات للدراسة بدون إنترنت؟',
      'answer':
          'نعم، يمكنك تحميل جميع الملفات والمراجع للدراسة في وضع عدم الاتصال.',
    },
    {
      'question': 'كم عدد الأسئلة المتوفرة في التطبيق؟',
      'answer':
          'يتوفر ما لا يقل عن 10,000 اختبار، مع تحديثات مستمرة وإضافة المزيد بشكل دوري.',
    },
    {
      'question': 'هل يمكنني إلغاء اشتراكي في أي وقت؟',
      'answer': 'نعم، يمكنك إلغاء اشتراكك في أي وقت من خلال إعدادات حسابك.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'الأسئلة الشائعة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        // leading: SizedBox(),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return FAQCard(
            question: faqItems[index]['question']!,
            answer: faqItems[index]['answer']!,
          );
        },
      ),
    );
  }
}

class FAQCard extends StatefulWidget {
  final String question;
  final String answer;

  const FAQCard({
    super.key,
    required this.question,
    required this.answer,
  });
  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;
  late final GlobalKey contentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: AnimatedRaisedButtonWithChild(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).brightness.isDark
            ? Colors.blueGrey.withAlpha(70)
            : null,
        shadowOffset: 3,
        lerpValue: 0.1,
        borderWidth: 1.5,
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Question Section (Always Visible)
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Answer Section (Animated)
            ClipRRect(
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  key: contentKey,
                  height: isExpanded ? null : 0,
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    bottom: isExpanded ? 20 : 0,
                  ),
                  child: Text(
                    widget.answer,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
