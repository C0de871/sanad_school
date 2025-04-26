// login_screen.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import '../../../../../core/Routes/app_routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../cubit/obscure_cubit/obsecure_cubit.dart';
import '../../widgets/animated_logo.dart';
import '../../widgets/animated_raised_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    AnimatedLogo(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    _helloText(context),
                    const SizedBox(height: 8),
                    _signInText(context),
                    const SizedBox(height: 32),
                    _signInForm(context),
                    const SizedBox(height: 24),
                    _signInButton(context),
                    const SizedBox(height: 16),
                    _createAccountTextAndButton(context),
                    const SizedBox(height: 8),
                    _resetPasswordTextAndButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormContainer _signInForm(BuildContext context) {
    return FormContainer(
      child: Column(
        children: [
          _emailField(context),
          const SizedBox(height: 16),
          _passwordField(context),
        ],
      ),
    );
  }

  Row _createAccountTextAndButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dontHaveAccountText(),
        _createAccountButton(context),
      ],
    );
  }

  Row _resetPasswordTextAndButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _forgetPasswordText(),
        _resetPasswordButton(context),
      ],
    );
  }

  TextButton _createAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.signUp,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Text(
        'إنشاء حساب',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  TextButton _resetPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.enterEmail,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Text(
        'استعد كلمة المرور',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Text _dontHaveAccountText() {
    return Text(
      'ليس لديك حساب؟',
      // style: TextStyle(color: Colors.grey[600]),
      style: TextStyle(color: Theme.of(context).colorScheme.outline),
    );
  }

  Text _forgetPasswordText() {
    return Text(
      'نسيت كلمة المرور؟',
      // style: TextStyle(color: Colors.grey[600]),
      style: TextStyle(color: Theme.of(context).colorScheme.outline),
    );
  }

  AnimatedRaisedButton _signInButton(BuildContext context) {
    return AnimatedRaisedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //todo manar: here we will call the login api
          //todo manar: the pushNamedAndRemoveUntil should be in the listener of the cubit not here
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) {
            return false;
          });
        }
      },
      text: 'تسجيل الدخول',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
    );
  }

  BlocBuilder<ObsecureCubit, bool> _passwordField(BuildContext context) {
    return BlocBuilder<ObsecureCubit, bool>(
      builder: (context, state) {
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
                state ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: () {
                context.read<ObsecureCubit>().showHidePassword();
              },
            ),
          ),
          obscureText: state,
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
      },
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
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!value.contains('@')) {
          return 'الرجاء إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }

  Text _signInText(BuildContext context) {
    return Text(
      'سجل دخول للوصول إلى حسابك',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // color: Colors.grey[600],
            color: Theme.of(context).colorScheme.outline,
          ),
      textAlign: TextAlign.center,
    );
  }

  Text _helloText(BuildContext context) {
    return Text(
      'مرحباً بك',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
      textAlign: TextAlign.center,
    );
  }
}
