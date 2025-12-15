// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flearn/screens/home_screen.dart';
import 'package:flearn/screens/lesson_screen.dart';
import 'package:flearn/screens/practice_screen.dart';
import 'package:flearn/screens/assessment_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'lesson/:phaseId/:lessonId',
          builder: (BuildContext context, GoRouterState state) {
            final phaseId = int.parse(state.pathParameters['phaseId']!);
            final lessonId = int.parse(state.pathParameters['lessonId']!);
            return LessonScreen(phaseId: phaseId, lessonId: lessonId);
          },
        ),
        GoRoute(
          path: 'practice/:phaseId/:lessonId',
          builder: (BuildContext context, GoRouterState state) {
            final phaseId = int.parse(state.pathParameters['phaseId']!);
            final lessonId = int.parse(state.pathParameters['lessonId']!);
            return PracticeScreen(phaseId: phaseId, lessonId: lessonId);
          },
        ),
        GoRoute(
          path: 'assessment/:phaseId/:lessonId',
          builder: (BuildContext context, GoRouterState state) {
            final phaseId = int.parse(state.pathParameters['phaseId']!);
            final lessonId = int.parse(state.pathParameters['lessonId']!);
            return AssessmentScreen(phaseId: phaseId, lessonId: lessonId);
          },
        ),
      ],
    ),
  ],
);
