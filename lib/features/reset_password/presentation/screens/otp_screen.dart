import 'package:flutter/material.dart';

import '../../../../core/Routes/app_routes.dart';
import '../../../../core/shared/widgets/Pin_Put/only_bottom_cursor_pin_put.dart';
import '../../../../core/shared/widgets/step_indicator.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/constants/app_numbers.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../auth/presentation/widgets/animated_raised_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "استعادة كلمة المرور", // Use localized text here
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: padding4 * 12),
              _otpText(context),
              const SizedBox(height: 8),
              _enterOtpText(context),
              buildTimer(),
              const SizedBox(height: padding4 * 12),
              const OnlyBottomCursor(),
              const SizedBox(
                height: padding4 * 12,
              ),
              Column(
                children: [
                  _verfiyOtp(context),
                  const SizedBox(height: padding4 * 6),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "اطلب رمز تحقق جديد", // Use localized text here
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StepIndicator(index: 1, length: 3),
            ],
          ),
        ),
      ),
    );
  }

  Text _enterOtpText(BuildContext context) {
    return Text(
      'أدخل رمز التحقق المرسل الى بريدك لتغيير كلمة المرور',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          // color: Colors.grey[600],
          color: Theme.of(context).colorScheme.outline),
      textAlign: TextAlign.center,
    );
  }

  Text _otpText(BuildContext context) {
    return Text(
      'رمز التحقق',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            // color: Colors.black87,
          ),
      textAlign: TextAlign.center,
    );
  }

  AnimatedRaisedButton _verfiyOtp(BuildContext context) {
    return AnimatedRaisedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.resetPasswrod,
        );
      },
      text: 'تأكيد رمز التحقق',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
    );
  }

  Row buildTimer() {
    int totalTimeInSeconds = 5 * 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _youCanResendCodeInText(context),
        TweenAnimationBuilder(
          tween: Tween(begin: totalTimeInSeconds.toDouble(), end: 0.0),
          duration: Duration(seconds: totalTimeInSeconds),
          builder: (context, value, child) {
            int remainingTimeInSeconds = value.toInt();
            int remainingMinutes = remainingTimeInSeconds ~/ 60;
            int remainingSeconds = remainingTimeInSeconds % 60;

            String formattedTime = '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

            return Text(
              formattedTime,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          onEnd: () {},
        ),
      ],
    );
  }
}

Text _youCanResendCodeInText(BuildContext context) {
  return Text(
    'يمكنك طلب رمز جديد خلال   ',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
        // color: Colors.grey[600],
        color: Theme.of(context).colorScheme.outline),
    textAlign: TextAlign.center,
  );
}
