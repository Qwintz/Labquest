import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:provider/provider.dart';

import '../../entities/course/course.dart';
import '../../providers/course_form_provider.dart';
import '../../providers/courses_provider.dart';
import '../components/bottom_sheet.dart';
import '../components/course_form.dart';
import '../navigation/navigation.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courses = context.watch<CoursesProvider>().courses;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.coursesPageTitle),
        leading: IconButton(
          icon: const Icon(FluentIcons.list_24_filled),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavigationRoutes.settings),
        ),
      ),
      body: courses?.isNotEmpty ?? true
          ? ImplicitlyAnimatedList<Course>(
              itemData: courses ?? <Course>[],
              itemBuilder: (context, course) {
                return Builder(
                  builder: (context) {
                    var taskCount = context.select((CoursesProvider provider) {
                      return provider.getTaskCount(course.key);
                    });
                    var completionPercent =
                        context.select((CoursesProvider provider) {
                      return provider.getCompletionPercent(course.key);
                    });
                    return ListTile(
                      title: Text(course.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Text(course.professor ?? ""),
                          const SizedBox(height: 24.0),
                          Text(AppLocalizations.of(context)!
                              .taskCount(taskCount)),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: completionPercent,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              completionPercent != 1.0
                                  ? const Icon(
                                      FluentIcons.checkbox_unchecked_24_filled)
                                  : const Icon(
                                      FluentIcons.checkbox_checked_24_filled),
                            ],
                          ),
                        ],
                      ),
                      leading:
                          const Icon(FluentIcons.document_one_page_24_filled),
                      minLeadingWidth: 24.0,
                      minVerticalPadding: 16.0,
                      onTap: () => Navigator.of(context)
                          .pushNamed(
                            NavigationRoutes.tasks,
                            arguments: course,
                          )
                          .then((_) =>
                              context.read<CoursesProvider>().loadMetaData()),
                      onLongPress: () {
                        openBottomSheet(
                          context: context,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.edit),
                                leading: const Icon(FluentIcons.edit_24_filled),
                                minLeadingWidth: 24.0,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  openBottomSheet(
                                    context: context,
                                    child: ChangeNotifierProvider(
                                      create: (context) =>
                                          CourseFormProvider(course: course),
                                      child: const CourseForm(),
                                    ),
                                    onClose: (newCourse) {
                                      newCourse != null
                                          ? context
                                              .read<CoursesProvider>()
                                              .updateCourse(
                                                  course, newCourse as Course)
                                          : null;
                                    },
                                  );
                                },
                              ),
                              ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.remove,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                leading: Icon(
                                  FluentIcons.delete_24_filled,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                minLeadingWidth: 24.0,
                                onTap: () {
                                  context
                                      .read<CoursesProvider>()
                                      .removeCourse(course);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/no_courses.svg',
                    height: 240.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    AppLocalizations.of(context)!.noCourses,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomSheet(
            context: context,
            child: ChangeNotifierProvider(
              create: (context) => CourseFormProvider(),
              child: const CourseForm(),
            ),
            onClose: (course) {
              course != null
                  ? context.read<CoursesProvider>().addCourse(course as Course)
                  : null;
            },
          );
        },
        child: const Icon(FluentIcons.add_24_filled),
      ),
    );
  }
}
