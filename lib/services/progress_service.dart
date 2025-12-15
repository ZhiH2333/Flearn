// lib/services/progress_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _progressKey = 'completed_lessons';

  // 保存已完成的课程 ID (phaseId-lessonId)
  Future<void> saveCompletedLesson(int phaseId, int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$phaseId-$lessonId';
    final completedLessons = prefs.getStringList(_progressKey) ?? [];
    if (!completedLessons.contains(key)) {
      completedLessons.add(key);
      await prefs.setStringList(_progressKey, completedLessons);
      // 通知监听者进度已更新
      // Note: 在实际应用中，这里应该触发一个 Riverpod StateNotifierProvider 的更新
    }
  }

  // 获取所有已完成的课程 ID
  Future<List<String>> getCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_progressKey) ?? [];
  }

  // 检查某个课程是否已完成
  Future<bool> isLessonCompleted(int phaseId, int lessonId) async {
    final completedLessons = await getCompletedLessons();
    return completedLessons.contains('$phaseId-$lessonId');
  }
}

final progressServiceProvider = Provider((ref) => ProgressService());

// 状态提供者，用于监听进度变化
final completedLessonsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(progressServiceProvider).getCompletedLessons();
});

// 辅助 Provider，用于计算总进度 (需要 CourseService)
// 假设总课程数是固定的，这里我们先用一个简单的 FutureProvider 来计算
final overallProgressProvider = FutureProvider<double>((ref) async {
  final completedLessons = await ref.watch(completedLessonsProvider.future);
  final course = await ref.watch(courseDataProvider.future);

  int totalLessons = 0;
  for (var phase in course.phases) {
    totalLessons += phase.lessons.length;
  }

  if (totalLessons == 0) return 0.0;

  return completedLessons.length / totalLessons;
});
