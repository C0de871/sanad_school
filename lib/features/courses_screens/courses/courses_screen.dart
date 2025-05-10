import 'package:flutter/material.dart';
import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../course_details/course_details_screen.dart';

final class StringsManager {
  static const String chooseTeacher = "اختر الاستاذ الذي تريد";
  static const String duration = "المدة";
  static const String price = "السعر";
  static const String details = "التفاصيل";
  static const String register = "تسجيل";
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class Course {
  final int id;
  final String title;
  final String details;
  final String time;
  final String price;
  final String imageUrl;
  bool isExpanded;
  bool isLocked;

  Course({
    required this.id,
    required this.title,
    required this.details,
    required this.time,
    required this.price,
    required this.imageUrl,
    required this.isExpanded,
    required this.isLocked,
  });
}

class _CoursesScreenState extends State<CoursesScreen> {
  static final _courses = List.generate(
    5,
    (index) => Course(
      id: index,
      title: "اسم الأستاذ / الكورس ${index + 1}",
      details: " تفاصيل قليلة مشان التيست",
      time: "10:00",
      price: "100000 ل.س",
      imageUrl: 'https://miro.medium.com/v2/resize:fit:1100/format:webp/1*DVZpduGGdESDwbcT4dQyVA.png',
      isExpanded: false,
      isLocked: true,
    ),
  );

  static final _expansionTileTheme = ThemeData(
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00415e91)),
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: Colors.transparent,
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: appBar(scheme),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text(
              '${StringsManager.chooseTeacher} :',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 22),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Theme(
                    data: _expansionTileTheme,
                    child: ExpansionTile(
                      showTrailingIcon: false,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          course.isExpanded = expanded;
                        });
                      },
                      expansionAnimationStyle: AnimationStyle(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      title: ImageAndTitle(scheme: scheme, course: course),
                      children: <Widget>[
                        DetailsContainer(
                          scheme: scheme,
                          isExpanded: course.isExpanded,
                          course: course,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(ColorScheme scheme) {
    return AppBar(
      centerTitle: true,
      title: Text("الكيمياء", style: TextStyle(color: scheme.onPrimary)),
      backgroundColor: scheme.primary,
      leading: Icon(Icons.arrow_back, color: scheme.onPrimary),
      actions: [Icon(Icons.menu_book, color: scheme.onPrimary)],
    );
  }
}
// #########################################################################
// !UPPER PART

class ImageAndTitle extends StatelessWidget {
  const ImageAndTitle({super.key, required this.scheme, required this.course});

  final ColorScheme scheme;
  final Course course;

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = course.isExpanded;
    const Duration animationDuration = Duration(milliseconds: 500);
    const double cornerRadius = 24.0;
    return Stack(
      children: [
        AnimatedContainer(
          duration: animationDuration,
          height: 320,
          decoration: BoxDecoration(
            borderRadius: isExpanded ? null : BorderRadius.circular(cornerRadius),
            boxShadow: [
              BoxShadow(
                color: scheme.primaryContainer.withOpacity(0.5),
                blurStyle: BlurStyle.solid,
                spreadRadius: isExpanded ? 0 : 2,
                offset: const Offset(0, 8), // Adjust as needed
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          height: 320,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                child: Image.network(
                  course.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(child: CoolLoadingScreen());
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                height: 80,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                child: Center(
                  child: Text(
                    course.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// #########################################################################
// !LOWER PART

class DetailsContainer extends StatelessWidget {
  const DetailsContainer({
    super.key,
    required this.scheme,
    required this.isExpanded,
    required this.course,
  });

  final ColorScheme scheme;
  final bool isExpanded;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.none,
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildInfoRow(StringsManager.duration, course.time),
            _buildInfoRow(StringsManager.price, course.price),
            const SizedBox(height: 8),
            const Text(
              '${StringsManager.details} :',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            Text(
              course.details,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailsScreen(
                      courseId: course.id,
                      courseTitle: course.title,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                ),
                child: const Text(StringsManager.register),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        Text(
          "$label : ",
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
