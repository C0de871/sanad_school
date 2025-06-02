import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/settings/presentation/cubit/theme_cubit.dart';

import '../../../../core/Routes/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/constants/constant.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../auth/presentation/widgets/animated_raised_button.dart';
import '../cubits/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'profile-avatar',
            child: CircleAvatar(
              radius: 50,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Text(
                '${cubit.firstNameController.text} ${cubit.lastNameController.text}',
                style: Theme.of(context).textTheme.headlineSmall,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileGeneralInfo extends StatelessWidget {
  const ProfileGeneralInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات العامة',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 16),
        FormTextField(
          label: 'الاسم الأول',
          controller: cubit.firstNameController,
          icon: Icons.person_outline,
        ),
        FormTextField(
          label: 'اسم العائلة',
          controller: cubit.lastNameController,
          icon: Icons.people_outline,
        ),
        FormTextField(
          label: 'اسم الأب',
          controller: cubit.fatherNameController,
          icon: Icons.person_2_outlined,
        ),
        FormTextField(
          label: 'اسم المدرسة',
          controller: cubit.schoolNameController,
          icon: Icons.school_outlined,
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return FormDropdownField(
              label: 'نوع الشهادة',
              value: cubit.selectedCertificate,
              items: [
                DropdownMenuItem(
                  value: cubit.selectedCertificate,
                  child: Text(
                    cubit.selectedCertificate,
                  ),
                ),
              ],
              // onChanged: (value) => cubit.updateCertificateType(value),
              icon: Icons.category_outlined,
            );
          },
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return FormDropdownField(
              label: 'المدينة',
              value: cubit.selectedCity,
              items: Constant.syrianCitiesMap.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key, // English key
                  child: Text(entry.value), // Arabic name
                );
              }).toList(),
              // onChanged: (value) => cubit.updateCity(value),
              icon: Icons.location_city_outlined,
            );
          },
        ),
      ],
    );
  }
}

class ProfileAccountInfo extends StatelessWidget {
  const ProfileAccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('معلومات الحساب', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        FormTextField(
          label: 'البريد الإلكتروني',
          controller: cubit.emailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        FormTextField(
          label: 'رقم الهاتف',
          controller: cubit.phoneController,
          icon: Icons.phone_iphone,
          // obscureText: true,
        ),
      ],
    );
  }
}

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = ['اشتراكاتي', 'اسئلة شائعة', 'حول التطبيق'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الإجراءات', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnimatedRaisedButtonWithChild(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              shadowColor: getIt<AppTheme>().isDark
                  ? Colors.blueGrey.withAlpha(70)
                  : null,
              shadowOffset: 3,
              lerpValue: 0.1,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(16),
              onPressed: () {
                switch (actions[index]) {
                  case 'اشتراكاتي':
                    Navigator.pushNamed(
                      context,
                      AppRoutes.subscription,
                    );
                  case 'اسئلة شائعة':
                    Navigator.pushNamed(
                      context,
                      AppRoutes.questionsAndAnswers,
                    );
                  case 'حول التطبيق':
                    Navigator.pushNamed(
                      context,
                      AppRoutes.aboutSanad,
                    );
                }
              },
              child: Center(
                child: Text(
                  actions[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        ProfileThemeSelector(),
      ],
    );
  }
}

class ProfileThemeSelector extends StatelessWidget {
  const ProfileThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemeCubit>();
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ListTile(
          title: const Text('وضع العرض'),
          trailing: PopupMenuButton<ThemeMode>(
            initialValue: state.themeMode,
            onSelected: (ThemeMode mode) {
              cubit.changeTheme(mode);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('فاتح'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('داكن'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('تلقائي'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: getIt<AppTheme>().isDark
                    ? Color(0xFF4F5E63)
                    : Color(0xFFB0B0AD),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: getIt<AppTheme>().isDark
                  ? Color(0xFF202F36)
                  : Color.fromARGB(255, 238, 239, 245),
              filled: true,
              prefixIcon: Icon(
                icon,
                color: getIt<AppTheme>().isDark
                    ? Color(0xFF4F5E63)
                    : Color(0xFFB0B0AD),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark
                      ? Color(0xFF384448)
                      : Color.fromARGB(255, 210, 210, 210),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark
                      ? Color(0xFF384448)
                      : Color.fromARGB(255, 146, 146, 146),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?>? onChanged;
  final IconData icon;

  const FormDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: getIt<AppTheme>().isDark
                    ? Color(0xFF4F5E63)
                    : Color(0xFFB0B0AD),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items,
            icon: onChanged == null ? SizedBox.shrink() : null,
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: getIt<AppTheme>().isDark
                  ? Color(0xFF202F36)
                  : Color.fromARGB(255, 238, 239, 245),
              filled: true,
              prefixIcon: Icon(
                icon,
                color: getIt<AppTheme>().isDark
                    ? Color(0xFF4F5E63)
                    : Color(0xFFB0B0AD),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark
                      ? Color(0xFF384448)
                      : Color.fromARGB(255, 210, 210, 210),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark
                      ? Color(0xFF384448)
                      : Color.fromARGB(255, 146, 146, 146),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
