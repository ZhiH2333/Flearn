// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 配色定义
  static const Color primaryColor = Color(0xFF54C5F8); // Flutter Blue
  static const Color accentColor = Color(0xFF00B4AB); // Dart Teal
  static const Color backgroundColor = Color(0xFF1E1E1E); // 深色背景
  static const Color successColor = Color(0xFF39FF14); // 霓虹绿
  static const Color errorColor = Color(0xFFFF4500); // 警示红

  // 基础文本样式
  static const TextStyle _baseTextStyle = TextStyle(fontFamily: 'Roboto');
  // 代码等宽字体
  static const TextStyle _codeTextStyle = TextStyle(fontFamily: 'monospace');

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: Color(0xFF252525), // 卡片和表面颜色
        error: errorColor,
      ),
      // 字体设置
      textTheme: TextTheme(
        displayLarge: _baseTextStyle.copyWith(fontSize: 57, fontWeight: FontWeight.bold),
        displayMedium: _baseTextStyle.copyWith(fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: _baseTextStyle.copyWith(fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: _baseTextStyle.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: _baseTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
        headlineSmall: _baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: _baseTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: _baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: _baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: _baseTextStyle.copyWith(fontSize: 16),
        bodyMedium: _baseTextStyle.copyWith(fontSize: 14),
        bodySmall: _baseTextStyle.copyWith(fontSize: 12),
        labelLarge: _baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
        labelMedium: _baseTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
        labelSmall: _baseTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      // 卡片主题 (圆角卡片)
      cardTheme: CardTheme(
        color: const Color(0xFF252525),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      // AppBar 主题 (玻璃拟态效果 - 简化为半透明)
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _baseTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // 代码块样式 (用于 flutter_syntax_view)
      extensions: <ThemeExtension<dynamic>>[
        CodeTheme(
          codeTextStyle: _codeTextStyle.copyWith(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// 自定义 ThemeExtension 用于代码样式
class CodeTheme extends ThemeExtension<CodeTheme> {
  final TextStyle codeTextStyle;

  const CodeTheme({required this.codeTextStyle});

  @override
  CodeTheme copyWith({TextStyle? codeTextStyle}) {
    return CodeTheme(
      codeTextStyle: codeTextStyle ?? this.codeTextStyle,
    );
  }

  @override
  CodeTheme lerp(covariant ThemeExtension<CodeTheme>? other, double t) {
    if (other is! CodeTheme) {
      return this;
    }
    return CodeTheme(
      codeTextStyle: TextStyle.lerp(codeTextStyle, other.codeTextStyle, t)!,
    );
  }
}
