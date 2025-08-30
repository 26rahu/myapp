import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/service/taskService.dart';

// this thing is like boss for all tasks
class TaskProvider extends ChangeNotifier {
  final TaskService taskService = TaskService(); // this is like helper who go talk to cloud
  List<Task> tasks = []; // all my tasks live in this list

  // this get all tasks from cloud and put in phone
  Future<void> loadTasks() async {
    tasks = await taskService.fetchTask(); // ask cloud for tasks
    notifyListeners(); // tell app "yo we got tasks now"
  }

  Future<void> addTask(String name) async {
    // check name not empty cuz empty name is silly
    if (name.trim().isNotEmpty) {
      // tell cloud to save new task
      final id = await taskService.addTask(name); // cloud give me id number
      // put new task in our list too
      tasks.add(Task(id: id, name: name, completed: false)); // new baby task yay
      notifyListeners(); // tell app new task is here wooo
    }
  }

  Future<void> updateTask(int index, bool completed) async {
    // find the task by its number place
    final task = tasks[index]; // gotcha little task
    // tell cloud this task done or not
    await taskService.updateTask(task.id, completed); // hey cloud, mark done or no
    // update in our list too so same same
    tasks[index] = Task(id: task.id, name: task.name, completed: completed); // fixed it yay
    notifyListeners(); // tell app we fixed it
  }

  Future<void> removeTask(int index) async {
    // find the task in list
    final task = tasks[index]; // oh you going away
    // tell cloud to delete it
    await taskService.deleteTasks(task.id); // cloud remove it forever
    // remove from our list too bye bye
    tasks.removeAt(index); // gone poof
    notifyListeners(); // tell app it gone now
  }
}
