import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduler_app/models/task.dart';

import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  final Box<Task> taskBox = Hive.box<Task>('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduler'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskFormScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: taskBox.listenable(),
          builder: (context, Box<Task> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text('No task scheduled'),
              );
            }

            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final task = box.getAt(index)!;
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          task.isCompleted = value!;
                          task.save();
                        }),
                    onLongPress: () {
                      task.delete();
                    },
                  );
                });
          }),
    );
  }
}
