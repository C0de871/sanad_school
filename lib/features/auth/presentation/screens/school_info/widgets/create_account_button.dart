import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../cubit/auth_cubit/auth_cubit.dart';
import '../../../widgets/animated_raised_button.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AnimatedRaisedButtonWithChild(
            width: 300,
            height: 50,
            borderRadius:
                BorderRadius.circular(12), // Set the border radius here
            onPressed: isLoading
                ? null
                : () {
                    if (context
                        .read<AuthCubit>()
                        .schoolInfoFormKey
                        .currentState!
                        .validate()) {
                      context.read<AuthCubit>().register();
                    }
                  },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            // shadowColor: AppTheme.extendedColorOf(context).buttonShadow,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Center(
              child: isLoading
                  ? LoadingDots(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : const Text(
                      'إنشاء الحساب',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ));
      },
    );
  }
}
