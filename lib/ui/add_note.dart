import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todolocal/constants/widgets/default_text_field.dart';
import 'package:todolocal/model/task.dart';
import 'package:todolocal/utils/database_helper.dart';

class AddNote extends StatelessWidget {
  AddNote({Key? key}) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Add Note'),
        titleTextStyle: Theme.of(context).textTheme.headline1,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 25,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              formField(titleController, hinttext: 'Title',
                  validation: (String? value) {
                if (value!.isEmpty) {
                  return 'Title is required';
                }
                return null;
              }),
              formField(descriptionController, hinttext: 'Description',
                  validation: (String? value) {
                if (value!.isEmpty) {
                  return 'Description is required';
                }
                return null;
              }),
              formField(durationController,
                  validation: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please select time duration for the task';
                    }
                    return null;
                  },
                  hinttext: 'Task Duration',
                  readOnly: true,
                  ontap: () async {
                    final Duration? duration = await showDurationPicker(
                        context: context,
                        initialTime: const Duration(minutes: 10),
                        baseUnit: BaseUnit.second,
                        snapToMins: 5.0);

                    durationController.text = duration!.inMinutes.toString() +
                        ':' +
                        (duration.inSeconds % 60).floor().toString() +
                        ' mins';
                  }),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Task task = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        taskDuration: durationController.text,
                        isCompleted: 0,
                      );
                      await Provider.of<DatabaseHelper>(context, listen: false)
                          .insertData(task);

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, padding: const EdgeInsets.all(12)),
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.button,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
