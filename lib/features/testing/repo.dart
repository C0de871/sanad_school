import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/Routes/app_routes.dart';
import '../../core/utils/services/service_locator.dart';
import '../subjects/data/data_sources/subject_local_data_source.dart';

class LessonRepository {
  final SubjectLocalDataSource dbHelper;

  LessonRepository({required this.dbHelper});

  Future<List<Lesson>> getLessonsWithTypes(int subjectId) async {
    // final data = await dbHelper.getLessonsWithQuestionTypes(subjectId);
    // log("lesson data: ${data.toString()}");
    return [];
    // return data.map((e) => Lesson.fromMap(e)).toList();
  }
}

// نموذج Lesson (ملف models/lesson.dart)
class Lesson {
  final int id;
  final String title;
  final int order;
  final List<String> questionTypes;

  Lesson({
    required this.id,
    required this.title,
    required this.order,
    required this.questionTypes,
  });

  factory Lesson.fromMap(Map<dynamic, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      questionTypes: (map['types'] as String).split(',').map((e) => e.trim()).toList(),
    );
  }
}

class Test1Screen extends StatelessWidget {
  final int subjectId;

  const Test1Screen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    final lessonRepo = LessonRepository(
      dbHelper: getIt<SubjectLocalDataSource>(),
    );

    return Scaffold(
      appBar: AppBar(title: Text('الدروس')),
      body: FutureBuilder<List<Lesson>>(
        future: lessonRepo.getLessonsWithTypes(subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // log("${snapshot.hasError}");
            return Center(child: Text('${snapshot.hasError}'));
          }

          final lessons = snapshot.data!;

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Card(
                child: ListTile(
                  title: Text(lesson.title),
                  subtitle: Text('أنواع الأسئلة: ${lesson.questionTypes.join(', ')}'),
                  trailing: Text('الترتيب: ${lesson.order}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.test2,
                      arguments: lesson.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Test2Screen extends StatelessWidget {
  final int lessonId;

  const Test2Screen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    // final dbHelper = getIt<SubjectLocalDataSourceImpl>();

    return Scaffold(
      appBar: AppBar(title: Text('الأسئلة')),
      body: SizedBox(),
    );
  }
}
