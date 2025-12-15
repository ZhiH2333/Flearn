// lib/screens/practice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:flearn/models/course_model.dart';
import 'package:flearn/services/course_service.dart';
import 'package:flearn/services/progress_service.dart';
import 'package:flearn/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  final int phaseId;
  final int lessonId;

  const PracticeScreen({super.key, required this.phaseId, required this.lessonId});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  final TextEditingController _controller = TextEditingController();
  Lesson? _lesson;
  bool _isCorrect = false;
  String _validationMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    final lesson = await ref.read(courseServiceProvider).getLesson(widget.phaseId, widget.lessonId);
    setState(() {
      _lesson = lesson;
      if (_lesson?.practice != null) {
        _controller.text = _lesson!.practice!.initialCode;
      }
    });
  }

  void _validateCode() {
    if (_lesson?.practice == null) return;

    final regex = RegExp(_lesson!.practice!.solutionRegex, multiLine: true);
    final code = _controller.text;

    if (regex.hasMatch(code)) {
      setState(() {
        _isCorrect = true;
        _validationMessage = '✅ 恭喜你！代码逻辑正确，你已经掌握了这个知识点！';
      });
      // 保存进度
      ref.read(progressServiceProvider).saveCompletedLesson(widget.phaseId, widget.lessonId);
      // 刷新进度
      ref.invalidate(completedLessonsProvider);
    } else {
      setState(() {
        _isCorrect = false;
        _validationMessage = '❌ 代码不符合要求。请仔细阅读说明，检查你的变量名、类型和分号。';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lesson == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final practice = _lesson!.practice;
    if (practice == null) {
      return const Scaffold(
        body: Center(child: Text('本课程没有实战演练')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('实战演练: ${_lesson!.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '任务说明',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  practice.instructions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              '你的代码',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            // 代码编辑器区域
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isCorrect ? AppTheme.successColor : Colors.white12,
                  width: 2,
                ),
              ),
              child: FlutterSyntaxView(
                code: _controller.text,
                syntax: Syntax.DART,
                syntaxTheme: SyntaxTheme.monokaiSublime(),
                withLineNumbers: true,
                expanded: true,
                fontSize: 14.0,
                withZoom: false,
                // 使用一个自定义的 Text Widget 来模拟编辑器的输入
                // 实际的 Flutter 应用中会使用 TextField 或 CodeEditor 库
                // 这里为了简化，我们使用一个可编辑的 TextField 替代
                // 暂时使用一个简单的 TextField
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    style: Theme.of(context).extension<CodeTheme>()?.codeTextStyle,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '输入你的代码...',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 校验结果
            if (_validationMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _validationMessage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                ),
              ),

            // 校验按钮
            Center(
              child: ElevatedButton.icon(
                onPressed: _validateCode,
                icon: const Icon(Icons.play_arrow),
                label: const Text('运行并校验代码'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            
            // 成功动画 (Lottie)
            if (_isCorrect)
              Center(
                child: Lottie.network(
                  'https://lottie.host/8557343e-3243-424a-8178-55428485257a/740444.json', // 示例 Lottie URL
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
