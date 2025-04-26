import 'package:flutter/material.dart';
import 'package:sanad_school/core/shared/widgets/step_indicator.dart';
import 'package:sanad_school/core/theme/theme.dart';
import 'package:sanad_school/core/utils/services/service_locator.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';
import 'package:sanad_school/features/auth/presentation/widgets/form_container.dart';

import '../../../../../core/Routes/app_routes.dart';

class SchoolInfoScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String fatherName;

  const SchoolInfoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
  });

  @override
  State<SchoolInfoScreen> createState() => _SchoolInfoScreenState();
}

class _SchoolInfoScreenState extends State<SchoolInfoScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  String? _selectedCity;
  String? _selectedCertificateType;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _syrianCities = [
    'دمشق',
    'حلب',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'دير الزور',
    'الرقة',
    'الحسكة',
    'القامشلي',
  ];

  final List<String> _certificateTypes = [
    'علمي',
    'أدبي',
    'تاسع',
  ];

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
    _schoolNameController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
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
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                  'مرحباً بك ${widget.firstName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.outline,
                    // color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AnimatedRaisedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil(
                      (route) => route.settings.name == AppRoutes.login,
                    );
                  },
                  text: 'تم',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _schoolInfoText(context),
                      const SizedBox(height: 8),
                      _enterSchoolInfoText(context),
                      const SizedBox(height: 32),
                      _schoolForm(context),
                      const SizedBox(height: 24),
                      _createAccountButton(context),
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
          _certificateDropDownButton(context),
        ],
      ),
    );
  }

  AnimatedRaisedButton _createAccountButton(BuildContext context) {
    return AnimatedRaisedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //todo manar: here we will call the create account api
          //todo manar: delete _showSuccessDialog from here and put it in the listener
          _showSuccessDialog();
        }
      },
      text: 'إنشاء الحساب',
      backgroundColor: Theme.of(context).colorScheme.primary,
      shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  DropdownButtonFormField<String> _certificateDropDownButton(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCertificateType,
      decoration: InputDecoration(
        labelText: 'نوع الشهادة',
        prefixIcon: Icon(
          Icons.card_membership_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      items: _certificateTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCertificateType = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء اختيار نوع الشهادة';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _cityDropDownButton(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      decoration: InputDecoration(
        labelText: 'المدينة',
        prefixIcon: Icon(
          Icons.location_city_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      items: _syrianCities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCity = newValue;
        });
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
      controller: _schoolNameController,
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
