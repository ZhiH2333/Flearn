// lib/screens/lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:flearn/models/course_model.dart';
import 'package:flearn/services/course_service.dart';
import 'package:flearn/theme/app_theme.dart';

class LessonScreen extends ConsumerWidget {
  final int phaseId;
  final int lessonId;

  const LessonScreen({super.key, required this.phaseId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsyncValue = ref.watch(
      FutureProvider.family<Lesson?, (int, int)>((ref, ids) {
        return ref.read(courseServiceProvider).getLesson(ids.$1, ids.$2);
      }, arg: (phaseId, lessonId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程学习'),
      ),
      body: lessonAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('加载失败: $err')),
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text('课程不存在'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 课程标题
                Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Divider(height: 30, color: Colors.white12),

                // 知识讲解 (Markdown 渲染)
                _buildSectionTitle(context, '知识讲解'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MarkdownBody(
                      data: lesson.contentMarkdown,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        p: Theme.of(context).textTheme.bodyLarge,
                        h1: Theme.of(context).textTheme.headlineLarge,
                        h2: Theme.of(context).textTheme.headlineMedium,
                        strong: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 代码示例 (代码高亮)
                _buildSectionTitle(context, '代码示例'),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: FlutterSyntaxView(
                    code: lesson.codeExample,
                    syntax: Syntax.DART,
                    syntaxTheme: SyntaxTheme.monokaiSublime(),
                    withLineNumbers: true,
                    expanded: true,
                    fontSize: 14.0,
                    backgroundColor: const Color(0xFF252525),
                  ),
                ),
                const SizedBox(height: 10),

                // 原理白话解说
                Card(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 原理白话解说', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.accentColor)),
                        const SizedBox(height: 8),
                        Text(
                          lesson.codeExplanation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 底部导航按钮
                _buildBottomNavigation(context, lesson),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, Lesson lesson) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (lesson.practice != null)
          ElevatedButton.icon(
            onPressed: () {
              context.go('/practice/$phaseId/$lessonId');
            },
            icon: const Icon(Icons.code),
            label: const Text('实战演练'),
          ),
        if (lesson.assessment != null)
          ElevatedButton.icon(
            onPressed: () {
              context.go('/assessment/$phaseId/$lessonId');
            },
            icon: const Icon(Icons.quiz),
            label: const Text('课后考核'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.black,
            ),
          ),
      ],
    );
  }
}
