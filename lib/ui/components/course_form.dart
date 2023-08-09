import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/course_form_provider.dart';

class CourseForm extends StatelessWidget {
  const CourseForm({super.key});

  @override
  Widget build(BuildContext context) {
    var step = context.select((CourseFormProvider provider) {
      return provider.currentStep;
    });
    var isNameValid = context.select((CourseFormProvider provider) {
      return provider.isNameValid;
    });
    var courseName = context.select((CourseFormProvider provider) {
      return provider.courseName;
    });
    var courseProfessor = context.select((CourseFormProvider provider) {
      return provider.courseProfessor;
    });
    var courseNote = context.select((CourseFormProvider provider) {
      return provider.courseNote;
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            context.read<CourseFormProvider>().course == null
                ? AppLocalizations.of(context)!.createCourseTitle
                : AppLocalizations.of(context)!.editCourseTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: IconButton(
            icon: const Icon(FluentIcons.checkmark_24_filled),
            onPressed: () {
              if (context.read<CourseFormProvider>().nameValidate()) {
                final course = context.read<CourseFormProvider>().save();
                Navigator.of(context).pop(course);
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
              subtitle: courseName.trim().isNotEmpty && step != 0
                  ? Text(courseName)
                  : null,
              isActive: step == 0 ? true : false,
              content: TextField(
                controller: context.read<CourseFormProvider>().inputController,
                onChanged: (name) {
                  context.read<CourseFormProvider>().courseName = name;
                  context.read<CourseFormProvider>().clearNameValidate();
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
              title: Text(AppLocalizations.of(context)!.professorStep),
              subtitle: courseProfessor.trim().isNotEmpty && step != 1
                  ? Text(courseProfessor)
                  : null,
              isActive: step == 1 ? true : false,
              content: TextField(
                controller: context.read<CourseFormProvider>().inputController,
                onChanged: (professor) => context
                    .read<CourseFormProvider>()
                    .courseProfessor = professor,
              ),
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.noteStep),
              subtitle: courseNote.trim().isNotEmpty && step != 2
                  ? Text(courseNote)
                  : null,
              isActive: step == 2 ? true : false,
              content: TextField(
                controller: context.read<CourseFormProvider>().inputController,
                maxLines: 5,
                onChanged: (note) =>
                    context.read<CourseFormProvider>().courseNote = note,
              ),
            ),
          ],
          controlsBuilder: (context, details) {
            return const SizedBox();
          },
          onStepTapped: (index) =>
              context.read<CourseFormProvider>().toStep(index),
        ),
      ],
    );
  }
}
