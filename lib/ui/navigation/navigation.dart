import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/course/course.dart';
import '../../providers/courses_provider.dart';
import '../../providers/tasks_provider.dart';
import '../pages/courses_page.dart';
import '../pages/profile_page.dart';
import '../pages/tasks_page.dart';

abstract class NavigationRoutes {
  static const home = '/';
  static const tasks = '/tasks';
  static const settings = '/settings';
}

abstract class NavigationRouteTransitions {
  static PageRouteBuilder slideTransition({
    Duration duration = const Duration(milliseconds: 300),
    required Offset beginOffset,
    required Widget Function(BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation)
        builder,
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      pageBuilder: builder,
    );
  }
}

class Navigation {
  static const initialRoute = NavigationRoutes.home;

  static Route<dynamic>? Function(RouteSettings)? onGenerateRoute =
      (RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case NavigationRoutes.home:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (context) => CoursesProvider(),
              child: const CoursesPage(),
            );
          },
        );
      case NavigationRoutes.tasks:
        return NavigationRouteTransitions.slideTransition(
          beginOffset: const Offset(1.0, 0),
          builder: (context, animation, secondaryAnimation) {
            var course = routeSettings.arguments as Course;
            return ChangeNotifierProvider(
              create: (context) => TasksProvider(course: course),
              child: const TasksPage(),
            );
          },
        );
      case NavigationRoutes.settings:
        return NavigationRouteTransitions.slideTransition(
          beginOffset: const Offset(1.0, 0),
          builder: (context, animation, secondaryAnimation) =>
              const ProfilePage(),
        );
      default:
        throw Exception("Unknown route name \"${routeSettings.name}\"");
    }
  };
}
