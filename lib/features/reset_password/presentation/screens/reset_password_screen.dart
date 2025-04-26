import 'package:flutter/material.dart';
import 'package:sanad_school/core/shared/widgets/step_indicator.dart';
import 'package:sanad_school/core/utils/services/service_locator.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import '../../../../../core/Routes/app_routes.dart';
import '../../../../../core/theme/theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
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
                    _newPasswordText(context),
                    const SizedBox(height: 8),
                    _enterNewPasswordText(context),
                    const SizedBox(height: 32),
                    _personalInfoForm(context),
                    const SizedBox(height: 24),
                    _continueButton(context),
                    const SizedBox(height: 16),
                    StepIndicator(index: 2, length: 3),
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
          _passwordField(context),
          const SizedBox(height: 16),
          _confirmPasswordField(context),
        ],
      ),
    );
  }

  AnimatedRaisedButton _continueButton(BuildContext context) {
    return AnimatedRaisedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamed(
            context,
            AppRoutes.login,
            arguments: [],
          );
        }
      },
      text: 'تأكيد',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
    );
  }

  TextFormField _confirmPasswordField(BuildContext context) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'تأكد من كلمة المرور',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      obscureText: _obscurePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء اعادة ادخال كلمة المرور';
        }
        if (_confirmPasswordController.text != _passwordController.text) {
          return 'كلمة المرور غير متطابقة';
        }
        return null;
      },
    );
  }

  TextFormField _passwordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      obscureText: _obscurePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  Text _enterNewPasswordText(BuildContext context) {
    return Text(
      'أدخل كلمة المرور الجديدة ',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          // color: Colors.grey[600],
          color: Theme.of(context).colorScheme.outline),
      textAlign: TextAlign.center,
    );
  }

  Text _newPasswordText(BuildContext context) {
    return Text(
      'كلمة المرور الجديدة',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            // color: Colors.black87,
          ),
      textAlign: TextAlign.center,
    );
  }
}
