import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduler_app/models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  String _description = '';

  DateTime _selectedDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (newValue) {
                    _description = newValue!;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final task = Task(
                            dateTime: _selectedDateTime,
                            description: _description,
                            title: _title);

                        final box = Hive.box<Task>("tasks");
                        await box.add(task);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Task'))
              ],
            )),
      ),
    );
  }
}
