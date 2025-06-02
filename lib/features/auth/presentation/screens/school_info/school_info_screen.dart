import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/shared/widgets/step_indicator.dart';
import 'package:sanad_school/core/theme/theme.dart';
import 'package:sanad_school/core/utils/constants/constant.dart';
import 'package:sanad_school/core/utils/services/service_locator.dart';
import 'package:sanad_school/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:sanad_school/features/auth/presentation/screens/school_info/widgets/certificate_dropdown_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import 'widgets/create_account_button.dart';

class SchoolInfoScreen extends StatefulWidget {
  const SchoolInfoScreen({
    super.key,
  });

  @override
  State<SchoolInfoScreen> createState() => _SchoolInfoScreenState();
}

class _SchoolInfoScreenState extends State<SchoolInfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext parentContext) {
    showGeneralDialog(
      context: parentContext,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تم إنشاء الحساب بنجاح!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'مرحباً بك ${parentContext.read<AuthCubit>().registerFirstNameController.text}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.outline,
                    // color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AnimatedRaisedButtonWithChild(
                    onPressed: () {
                      parentContext.read<AuthCubit>().emitLoginSuccess();
                    },
                    width: 300,
                    height: 50,
                    borderRadius:
                        BorderRadius.circular(12), // Set the border radius here
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    // shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Center(
                      child: const Text(
                        'تم',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('معلومات المدرسة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state) {
              case RegisterSuccess():
                _showSuccessDialog(context);
              case AuthFailure():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    duration:
                        Duration(seconds: 2), // Optional: how long it shows
                  ),
                );
              case _:
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: context.read<AuthCubit>().schoolInfoFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _schoolInfoText(context),
                        const SizedBox(height: 8),
                        _enterSchoolInfoText(context),
                        const SizedBox(height: 32),
                        _schoolForm(context),
                        const SizedBox(height: 24),
                        CreateAccountButton(),
                        const SizedBox(height: 16),
                        StepIndicator(index: 1, length: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormContainer _schoolForm(BuildContext context) {
    return FormContainer(
      child: Column(
        children: [
          _schoolNameField(context),
          const SizedBox(height: 16),
          _cityDropDownButton(context),
          const SizedBox(height: 16),
          CertificateDropdownButton(),
        ],
      ),
    );
  }

  DropdownButtonFormField<String> _cityDropDownButton(BuildContext context) {
    final selectedKey = context.read<AuthCubit>().selectedCity;

    return DropdownButtonFormField<String>(
      value: selectedKey,
      decoration: InputDecoration(
        labelText: 'المدينة',
        prefixIcon: Icon(
          Icons.location_city_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      items: Constant.syrianCitiesMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key, // English key
          child: Text(entry.value), // Arabic name
        );
      }).toList(),
      onChanged: (String? newKey) {
        context.read<AuthCubit>().selectedCity = newKey!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء اختيار المدينة';
        }
        return null;
      },
    );
  }

  TextFormField _schoolNameField(BuildContext context) {
    return TextFormField(
      controller: context.read<AuthCubit>().schoolNameController,
      decoration: InputDecoration(
        labelText: 'اسم المدرسة',
        prefixIcon: Icon(
          Icons.school_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال اسم المدرسة';
        }
        return null;
      },
    );
  }

  Text _enterSchoolInfoText(BuildContext context) {
    return Text(
      'أدخل معلومات مدرستك لإكمال إنشاء الحساب',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // color: Colors.grey[600],
            color: Theme.of(context).colorScheme.outline,
          ),
      textAlign: TextAlign.center,
    );
  }

  Text _schoolInfoText(BuildContext context) {
    return Text(
      'معلومات المدرسة',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
      textAlign: TextAlign.center,
    );
  }
}
