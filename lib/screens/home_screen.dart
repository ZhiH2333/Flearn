// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flearn/models/course_model.dart';
import 'package:flearn/services/course_service.dart';
import 'package:flearn/services/progress_service.dart';
import 'package:flearn/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsyncValue = ref.watch(courseDataProvider);
    final progressAsyncValue = ref.watch(overallProgressProvider);
    final completedLessonsAsyncValue = ref.watch(completedLessonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flearn - 学习路线图'),
        backgroundColor: AppTheme.backgroundColor.withOpacity(0.9),
      ),
      body: courseAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('加载失败: $err')),
        data: (course) {
          return progressAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('进度加载失败: $err')),
            data: (progress) {
              return completedLessonsAsyncValue.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('完成课程加载失败: $err')),
                data: (completedLessons) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressCard(context, progress),
                        const SizedBox(height: 24),
                        ...course.phases.map((phase) => _buildPhaseCard(context, phase, completedLessons)).toList(),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '当前学习进度',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              color: AppTheme.primaryColor,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard(BuildContext context, Phase phase, List<String> completedLessons) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: phase.id == 1, // 默认展开第一阶段
          title: Text(
            phase.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.accentColor),
          ),
          subtitle: Text(phase.description),
          children: phase.lessons.map((lesson) => _buildLessonTile(context, phase, lesson, completedLessons)).toList(),
        ),
      ),
    );
  }

  Widget _buildLessonTile(BuildContext context, Phase phase, Lesson lesson, List<String> completedLessons) {
    final isCompleted = completedLessons.contains('${phase.id}-${lesson.id}');

    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isCompleted ? AppTheme.successColor : Colors.white54,
      ),
      title: Text(lesson.title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // 导航到课程详情页
        context.go('/lesson/${phase.id}/${lesson.id}');
      },
    );
  }
}
