import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:provider/provider.dart';

import '../../entities/task/task.dart';
import '../../providers/task_form_provider.dart';
import '../../providers/tasks_provider.dart';
import '../components/bottom_sheet.dart';
import '../components/task_form.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pageTitle = context.read<TasksProvider>().pageTitle;
    var tasks = context.watch<TasksProvider>().tasks;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          maxLines: 2,
        ),
        leading: IconButton(
          icon: const Icon(FluentIcons.chevron_left_24_filled),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: tasks?.isNotEmpty ?? true
          ? ImplicitlyAnimatedList<Task>(
              itemData: tasks ?? <Task>[],
              itemBuilder: (context, task) => Builder(
                builder: (context) {
                  return ListTile(
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        task.note != null ? Text(task.note!) : const SizedBox(),
                        SizedBox(height: task.note != null ? 16.0 : 0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FluentIcons.calendar_month_24_filled,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8.0),
                            Text(task.deadline != null
                                ? AppLocalizations.of(context)!
                                    .deadline(task.deadline!)
                                : AppLocalizations.of(context)!.noDeadline),
                          ],
                        ),
                      ],
                    ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        task.isDone
                            ? const Icon(FluentIcons.checkbox_checked_24_filled)
                            : const Icon(
                                FluentIcons.checkbox_unchecked_24_filled),
                      ],
                    ),
                    minLeadingWidth: 24.0,
                    minVerticalPadding: 16.0,
                    onTap: () =>
                        context.read<TasksProvider>().changeTaskStatus(task),
                    onLongPress: () {
                      openBottomSheet(
                        context: context,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                task.isDone
                                    ? AppLocalizations.of(context)!
                                        .setUncompleted
                                    : AppLocalizations.of(context)!
                                        .setCompleted,
                              ),
                              leading: task.isDone
                                  ? const Icon(
                                      FluentIcons.checkbox_unchecked_24_filled)
                                  : const Icon(
                                      FluentIcons.checkbox_checked_24_filled),
                              minLeadingWidth: 24.0,
                              onTap: () {
                                context
                                    .read<TasksProvider>()
                                    .changeTaskStatus(task);
                                Navigator.of(context).pop();
                              },
                            ),
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
                                        TaskFormProvider(task: task),
                                    child: const TaskForm(),
                                  ),
                                  onClose: (newTask) {
                                    newTask != null
                                        ? context
                                            .read<TasksProvider>()
                                            .updateTask(task, newTask as Task)
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
                                context.read<TasksProvider>().removeTask(task);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/no_tasks.svg',
                    height: 240.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    AppLocalizations.of(context)!.noTasks,
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
              create: (context) => TaskFormProvider(),
              child: const TaskForm(),
            ),
            onClose: (task) {
              task != null
                  ? context.read<TasksProvider>().addTask(task as Task)
                  : null;
            },
          );
        },
        child: const Icon(FluentIcons.add_24_filled),
      ),
    );
  }
}
