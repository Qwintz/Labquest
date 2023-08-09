import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/task_form_provider.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    var step = context.select((TaskFormProvider provider) {
      return provider.currentStep;
    });
    var isNameValid = context.select((TaskFormProvider provider) {
      return provider.isNameValid;
    });
    var taskName = context.select((TaskFormProvider provider) {
      return provider.taskName;
    });
    var taskDeadline = context.select((TaskFormProvider provider) {
      return provider.taskDeadline;
    });
    var taskNote = context.select((TaskFormProvider provider) {
      return provider.taskNote;
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            context.read<TaskFormProvider>().task == null
                ? AppLocalizations.of(context)!.createTaskTitle
                : AppLocalizations.of(context)!.editTaskTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: IconButton(
            icon: const Icon(FluentIcons.checkmark_24_filled),
            onPressed: () {
              if (context.read<TaskFormProvider>().nameValidate()) {
                final task = context.read<TaskFormProvider>().save();
                Navigator.of(context).pop(task);
              }
            },
          ),
        ),
        Stepper(
          currentStep: step,
          type: StepperType.vertical,
          steps: [
            Step(
              title: Text(AppLocalizations.of(context)!.nameStep),
              subtitle: taskName.trim().isNotEmpty && step != 0
                  ? Text(taskName)
                  : null,
              isActive: step == 0 ? true : false,
              content: TextField(
                controller: context.read<TaskFormProvider>().inputController,
                onChanged: (name) {
                  context.read<TaskFormProvider>().taskName = name;
                  context.read<TaskFormProvider>().clearNameValidate();
                },
                decoration: InputDecoration(
                  errorText: isNameValid
                      ? null
                      : AppLocalizations.of(context)!.emptyFiendError,
                ),
              ),
              state: isNameValid ? StepState.indexed : StepState.error,
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.deadlineStep),
              subtitle: taskDeadline != null && step != 1
                  ? Text(AppLocalizations.of(context)!.deadline(taskDeadline))
                  : null,
              isActive: step == 1 ? true : false,
              content: TextField(
                controller: context.read<TaskFormProvider>().inputController,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(FluentIcons.calendar_month_24_filled),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        helpText: "",
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2077),
                      ).then(
                        (deadline) {
                          deadline != null
                              ? context.read<TaskFormProvider>().taskDeadline =
                                  deadline
                              : null;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.noteStep),
              subtitle: taskNote.trim().isNotEmpty && step != 2
                  ? Text(taskNote)
                  : null,
              isActive: step == 2 ? true : false,
              content: TextField(
                controller: context.read<TaskFormProvider>().inputController,
                maxLines: 5,
                onChanged: (note) =>
                    context.read<TaskFormProvider>().taskNote = note,
              ),
            ),
          ],
          controlsBuilder: (context, details) {
            return const SizedBox();
          },
          onStepTapped: (index) =>
              context.read<TaskFormProvider>().toStep(index),
        ),
      ],
    );
  }
}
