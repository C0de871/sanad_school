import 'package:flutter/material.dart';
import 'package:sanad_school/core/shared/widgets/step_indicator.dart';
import 'package:sanad_school/core/utils/services/service_locator.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import '../../../../../core/Routes/app_routes.dart';
import '../../../../../core/theme/theme.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();

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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
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
                    _personalInfoText(context),
                    const SizedBox(height: 8),
                    _enterYourInfoText(context),
                    const SizedBox(height: 32),
                    _personalInfoForm(context),
                    const SizedBox(height: 24),
                    _continueButton(context),
                    const SizedBox(height: 16),
                    StepIndicator(index: 0, length: 2),
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
          _firstNameField(context),
          const SizedBox(height: 16),
          _lastNameField(context),
          const SizedBox(height: 16),
          _fatherNameField(context),
          const SizedBox(height: 16),
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
            AppRoutes.completeSignUp,
            arguments: [
              _firstNameController.text,
              _lastNameController.text,
              _fatherNameController.text,
            ],
          );
        }
      },
      text: 'التالي',
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

  TextFormField _fatherNameField(BuildContext context) {
    return TextFormField(
      controller: _fatherNameController,
      decoration: InputDecoration(
        labelText: 'اسم الأب',
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال اسم الأب';
        }
        return null;
      },
    );
  }

  TextFormField _lastNameField(BuildContext context) {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'الاسم الأخير',
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال الاسم الأخير';
        }
        return null;
      },
    );
  }

  TextFormField _firstNameField(BuildContext context) {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'الاسم الأول',
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال الاسم الأول';
        }
        return null;
      },
    );
  }

  Text _enterYourInfoText(BuildContext context) {
    return Text(
      'أدخل معلوماتك الشخصية لإنشاء حساب جديد',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          // color: Colors.grey[600],
          color: Theme.of(context).colorScheme.outline),
      textAlign: TextAlign.center,
    );
  }

  Text _personalInfoText(BuildContext context) {
    return Text(
      'المعلومات الشخصية',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            // color: Colors.black87,
          ),
      textAlign: TextAlign.center,
    );
  }
}
