// lib/services/course_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flearn/models/course_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseService {
  Future<Course> loadCourseData() async {
    final String response = await rootBundle.loadString('assets/data/course_data.json');
    final data = await json.decode(response);
    return Course.fromJson(data);
  }

  // 辅助方法：根据 PhaseId 和 LessonId 获取单个 Lesson
  Future<Lesson?> getLesson(int phaseId, int lessonId) async {
    final course = await loadCourseData();
    try {
      final phase = course.phases.firstWhere((p) => p.id == phaseId);
      final lesson = phase.lessons.firstWhere((l) => l.id == lessonId);
      return lesson;
    } catch (e) {
      // 找不到对应的课程
      return null;
    }
  }
}

final courseServiceProvider = Provider((ref) => CourseService());

final courseDataProvider = FutureProvider<Course>((ref) async {
  return ref.watch(courseServiceProvider).loadCourseData();
});
