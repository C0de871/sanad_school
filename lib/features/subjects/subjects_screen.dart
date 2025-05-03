import 'package:flutter/material.dart';

import '../settings/presentation/settings_screen.dart';
import '../videos/video_screen.dart';
import 'presentation/widgets/custom_app_bar.dart';
import 'presentation/widgets/custom_bottom_nav_bar.dart';
import 'presentation/widgets/subject_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const SettingsScreen(),
    const SubjectsGrid(),
    const VideoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
