import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';

import '../../../core/Routes/app_routes.dart';
import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import 'cubits/profile_cubit.dart';
import 'widgets/profile_widgets.dart';

// Main Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreenContent();
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is LogoutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (s) => false,
          );
        } else if (state is FailedToLogout) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading && !state.isEditing) {
          return const Scaffold(
            body: Center(child: CoolLoadingScreen()),
          );
        }

        return PopScope(
          canPop: !context.read<ProfileCubit>().hasUnsavedChanges,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _onWillPop(context);
          },
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Future<void> _onWillPop(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    if (!cubit.hasUnsavedChanges) {
      Navigator.pop(context, true);
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حفظ التغييرات؟'),
        content: const Text('لديك تغييرات غير محفوظة. هل تريد حفظها؟'),
        actions: [
          TextButton(
            onPressed: () {
              cubit.discardChanges();
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              // cubit.saveChanges();
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'حسابي',
        style: TextStyle(
          color:
              getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
        ),
      ),
      forceMaterialTransparency: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          color: getIt<AppTheme>().isDark
              ? Color(0xFF384448)
              : Color.fromARGB(255, 210, 210, 210),
          height: 0,
          thickness: 1.0,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.maybePop(context),
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () => context.read<ProfileCubit>().saveChanges(),
      //     child: Text(
      //       'حفظ',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: Theme.of(context).colorScheme.primary,
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: context.read<ProfileCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),
              const SizedBox(height: 24),
              const ProfileGeneralInfo(),
              const SizedBox(height: 24),
              const ProfileAccountInfo(),
              const SizedBox(height: 24),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedRaisedButtonWithChild(
      onPressed: () {
        context.read<ProfileCubit>().logout();
      },
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      child: const Text('تسجيل الخروج'),
    );
  }
}
