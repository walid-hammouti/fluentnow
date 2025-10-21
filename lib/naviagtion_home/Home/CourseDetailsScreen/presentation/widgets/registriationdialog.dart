import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcourseregistration/course_registration_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationNotesDialog extends StatefulWidget {
  final String courseName;
  final String courseId;
  const RegistrationNotesDialog({
    super.key,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<RegistrationNotesDialog> createState() =>
      _RegistrationNotesDialogState();
}

class _RegistrationNotesDialogState extends State<RegistrationNotesDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseRegistrationCubit, CourseRegistrationState>(
      listener: (context, state) {
        if (state is CourseRegistrationSuccess) {
          Navigator.pop(context, true); // Return true on success
        } else if (state is CourseRegistrationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AlertDialog(
        title: Text('Register for ${widget.courseName}'),
        content: BlocBuilder<CourseRegistrationCubit, CourseRegistrationState>(
          builder: (context, state) {
            if (state is CourseRegistrationLoading) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text('Submitting registration...'),
                ],
              );
            }

            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                      hintText: 'Any special requests or comments...',
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocBuilder<CourseRegistrationCubit, CourseRegistrationState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed:
                    state is CourseRegistrationLoading
                        ? null
                        : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final notes = _notesController.text.trim();
                            context
                                .read<CourseRegistrationCubit>()
                                .insertCourseRegistration(
                                  widget.courseId,
                                  notes,
                                );
                          }
                        },
                child:
                    state is CourseRegistrationLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Submit'),
              );
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
