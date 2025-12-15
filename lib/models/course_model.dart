// lib/models/course_model.dart

class Course {
  final List<Phase> phases;

  Course({required this.phases});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      phases: (json['phases'] as List)
          .map((i) => Phase.fromJson(i))
          .toList(),
    );
  }
}

class Phase {
  final int id;
  final String title;
  final String description;
  final List<Lesson> lessons;

  Phase({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });

  factory Phase.fromJson(Map<String, dynamic> json) {
    return Phase(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      lessons: (json['lessons'] as List)
          .map((i) => Lesson.fromJson(i))
          .toList(),
    );
  }
}

class Lesson {
  final int id;
  final String title;
  final String contentMarkdown;
  final String codeExample;
  final String codeExplanation;
  final Assessment? assessment;
  final Practice? practice;

  Lesson({
    required this.id,
    required this.title,
    required this.contentMarkdown,
    required this.codeExample,
    required this.codeExplanation,
    this.assessment,
    this.practice,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      contentMarkdown: json['contentMarkdown'],
      codeExample: json['codeExample'],
      codeExplanation: json['codeExplanation'],
      assessment: json['assessment'] != null
          ? Assessment.fromJson(json['assessment'])
          : null,
      practice: json['practice'] != null
          ? Practice.fromJson(json['practice'])
          : null,
    );
  }
}

class Assessment {
  final List<Question> quiz;
  final List<Keyword> keywords;

  Assessment({required this.quiz, required this.keywords});

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      quiz: (json['quiz'] as List)
          .map((i) => Question.fromJson(i))
          .toList(),
      keywords: (json['keywords'] as List)
          .map((i) => Keyword.fromJson(i))
          .toList(),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}

class Keyword {
  final String word;
  final String hint;

  Keyword({required this.word, required this.hint});

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      word: json['word'],
      hint: json['hint'],
    );
  }
}

class Practice {
  final String instructions;
  final String initialCode;
  final String solutionRegex;

  Practice({
    required this.instructions,
    required this.initialCode,
    required this.solutionRegex,
  });

  factory Practice.fromJson(Map<String, dynamic> json) {
    return Practice(
      instructions: json['instructions'],
      initialCode: json['initialCode'],
      solutionRegex: json['solutionRegex'],
    );
  }
}
