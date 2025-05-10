import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../cubit/auth_cubit/auth_cubit.dart';
import '../../../widgets/animated_raised_button.dart';

class SignInButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SignInButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AnimatedRaisedButtonWithChild(
          width: 300,
          height: 50,
          borderRadius: BorderRadius.circular(12), // Set the border radius here
          onPressed: isLoading
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthCubit>().login();
                  }
                },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: LoadingDots(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
        );
      },
    );
  }
}
