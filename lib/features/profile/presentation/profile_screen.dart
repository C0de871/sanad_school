import 'package:flutter/material.dart';

import '../../../core/Routes/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';

// Main Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  // Form Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedCertificate = 'علمي';
  String _selectedCity = 'دمشق';
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _setupControllerValues();
    _setupControllerListeners();
  }

  void _setupControllerValues() {
    _firstNameController.text = 'محمد';
    _lastNameController.text = 'عايدي';
    _fatherNameController.text = 'علاء الدين';
    _schoolNameController.text = 'مدرسة العلوم';
    _emailController.text = 'muhammadaydi3@gmail.com';
    _passwordController.text = 'password123';
  }

  void _setupControllerListeners() {
    void listener() {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }

    _firstNameController.addListener(listener);
    _lastNameController.addListener(listener);
    _fatherNameController.addListener(listener);
    _schoolNameController.addListener(listener);
    _emailController.addListener(listener);
    _passwordController.addListener(listener);
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      Navigator.pop(context, true);
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حفظ التغييرات؟'),
        content: const Text('لديك تغييرات غير محفوظة. هل تريد حفظها؟'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _hasUnsavedChanges = false);
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              _saveChanges();
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveChanges() {
    // Implement save logic
    setState(() => _hasUnsavedChanges = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _onWillPop();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'حسابي',
        style: TextStyle(
          color: getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
        ),
      ),
      forceMaterialTransparency: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0), // Height of the bottom line
        child: Divider(
          color: getIt<AppTheme>().isDark ? Color(0xFF384448) : Color.fromARGB(255, 210, 210, 210), height: 0,
          thickness: 1.0, // Thickness of the line
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        TextButton(
          onPressed: _saveChanges,
          child: Text(
            'حفظ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildGeneralInfo(),
              const SizedBox(height: 24),
              _buildAccountInfo(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildThemeSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'profile-avatar',
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${_firstNameController.text} ${_lastNameController.text}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfo() {
    Color(0xFFB0B0AD);
    Color(0xFF4F5E63);
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
        _buildTextField(
          label: 'الاسم الأول',
          controller: _firstNameController,
          icon: Icons.person_outline,
        ),
        _buildTextField(
          label: 'اسم العائلة',
          controller: _lastNameController,
          icon: Icons.people_outline,
        ),
        _buildTextField(
          label: 'اسم الأب',
          controller: _fatherNameController,
          icon: Icons.person_2_outlined,
        ),
        _buildTextField(
          label: 'اسم المدرسة',
          controller: _schoolNameController,
          icon: Icons.school_outlined,
        ),
        _buildDropdownField(
          label: 'نوع الشهادة',
          value: _selectedCertificate,
          items: const ['علمي', 'ادبي', 'تاسع'],
          onChanged: (value) => setState(() => _selectedCertificate = value!),
          icon: Icons.category_outlined,
        ),
        _buildDropdownField(
          label: 'المدينة',
          value: _selectedCity,
          items: const ['دمشق', 'حلب', 'حمص', 'اللاذقية', 'طرطوس'],
          onChanged: (value) => setState(() => _selectedCity = value!),
          icon: Icons.location_city_outlined,
        ),
      ],
    );
  }

  Widget _buildAccountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('معلومات الحساب', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'البريد الإلكتروني',
          controller: _emailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          label: 'كلمة المرور',
          controller: _passwordController,
          icon: Icons.lock_outline,
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // final actions = ['اشتراكاتي', 'اسئلة شائعة', 'حول التطبيق', 'حول المطورين'];
    final actions = ['اشتراكاتي', 'اسئلة شائعة', 'حول التطبيق'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الإجراءات', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          // Icons
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnimatedRaisedButtonWithChild(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              shadowColor: getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null,
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
                  // case 'حول المطورين':
                  //   Navigator.pushNamed(
                  //     context,
                  //     AppRoutes.aboutDevelopers,
                  //   );
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
      ],
    );
  }

  Widget _buildThemeSelector() {
    return ListTile(
      title: const Text('وضع العرض'),
      trailing: PopupMenuButton<ThemeMode>(
        initialValue: _currentThemeMode,
        onSelected: (ThemeMode mode) {
          setState(() => _currentThemeMode = mode);
          // Implement theme change logic
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
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: getIt<AppTheme>().isDark ? Color(0xFF202F36) : Color.fromARGB(255, 238, 239, 245),
              filled: true,
              // labelText: label,
              prefixIcon: Icon(
                icon,
                color: getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark ? Color(0xFF384448) : Color.fromARGB(255, 210, 210, 210),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark ? Color(0xFF384448) : Color.fromARGB(255, 146, 146, 146),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: getIt<AppTheme>().isDark ? Color(0xFF202F36) : Color.fromARGB(255, 238, 239, 245),
              filled: true,
              // labelText: label,
              prefixIcon: Icon(
                icon,
                color: getIt<AppTheme>().isDark ? Color(0xFF4F5E63) : Color(0xFFB0B0AD),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark ? Color(0xFF384448) : Color.fromARGB(255, 210, 210, 210),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getIt<AppTheme>().isDark ? Color(0xFF384448) : Color.fromARGB(255, 146, 146, 146),
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _schoolNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
