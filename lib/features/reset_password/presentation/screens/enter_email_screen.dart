import 'package:flutter/material.dart';
import 'package:sanad_school/core/shared/widgets/step_indicator.dart';
import 'package:sanad_school/core/utils/services/service_locator.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import '../../../../../core/Routes/app_routes.dart';
import '../../../../../core/theme/theme.dart';

class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _personalEmailText(context),
                    const SizedBox(height: 8),
                    _enterYourEmailText(context),
                    const SizedBox(height: 32),
                    _personalInfoForm(context),
                    const SizedBox(height: 24),
                    _sendOtp(context),
                    const SizedBox(height: 16),
                    StepIndicator(index: 0, length: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormContainer _personalInfoForm(BuildContext context) {
    return FormContainer(
      child: Column(
        children: [
          _emailField(context),
        ],
      ),
    );
  }

  AnimatedRaisedButton _sendOtp(BuildContext context) {
    return AnimatedRaisedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //todo manar: here we will call the send otp api
          //todo manar: the pushnamed should be in the listener of the cubit not here
          Navigator.pushNamed(
            context,
            AppRoutes.otp,
            arguments: [
              _emailController.text,
            ],
          );
        }
      },
      text: 'ارسال رمز التحقق',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shadowColor: AppTheme.extendedColorOf(context).buttonShadow,
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        return null;
      },
    );
  }

  Text _enterYourEmailText(BuildContext context) {
    return Text(
      'أدخل بريدك الالكتروني لارسال رمز التحقق ',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          // color: Colors.grey[600],
          color: Theme.of(context).colorScheme.outline),
      textAlign: TextAlign.center,
    );
  }

  Text _personalEmailText(BuildContext context) {
    return Text(
      'البريد الشخصي',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            // color: Colors.black87,
          ),
      textAlign: TextAlign.center,
    );
  }
}
