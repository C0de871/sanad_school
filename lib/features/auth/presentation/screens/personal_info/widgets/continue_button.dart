import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../cubit/auth_cubit/auth_cubit.dart';
import '../../../widgets/animated_raised_button.dart';

class ContinueButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ContinueButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthCertificateTypesLoading;

        return AnimatedRaisedButtonWithChild(
            width: 300,
            height: 50,
            borderRadius:
                BorderRadius.circular(12), // Set the border radius here
            onPressed: isLoading
                ? null
                : () {
                    if (!isLoading && formKey.currentState!.validate()) {
                      context.read<AuthCubit>().fetchTypes();
                    }
                  },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            // shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Center(
              child: isLoading
                  ? LoadingDots(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : const Text(
                      'المتابعة',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ));
      },
    );
  }
}
