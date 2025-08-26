import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Task {
  final String id;
  final String name;
  final bool completed;

  Task({required this.id, required this.name, required this.completed});

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      name: data["name"] ?? "",
      completed: data["completed"] ?? false,
    );
  }
}

// define a task service to handle firestore operations
class TaskService {
  // firestore instnace in a alias
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // future returns a list of tasks using factory method defined in task class
  Future<List<Task>> fetchTask() async {
    // call get to retreve all of the documents inside the collections
    final snapshot = await db.collection('tasks').orderBy('timestamp').get();

    // snapshot of all documents is being mapped to factory object template
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.id, doc.data()))
        .toList();
  }

  // create the task
  Future<String> addTask(String name) async {
    final newTask = {
      'name': name,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final docRef = await db.collection('tasks').add(newTask);

    return docRef.id;
  }

  // update the task future
  Future<void> updateTask(String id, bool completed) async {
    await db.collection('tasks').doc(id).update({'completed': completed});
  }

  // delete the tasks form the database
  Future<void> deleteTasks(String id) async {
    await db.collection('tasks').doc(id).delete();
  }
}

// create a task provider to manange state
class TaskProvider extends ChangeNotifier {
  final TaskService taskService = TaskService();
  List<Task> tasks = [];

  // populates tasks list/array with documents form database notifies the root provideer of stateful change
  Future<void> loadTasks() async {
    tasks = await taskService.fetchTask();
    notifyListeners();
  }

  Future<void> addTask(String name) async {
    // check to see if name is not empty
    if (name.trim().isNotEmpty) {
      // add the trimmed task name to the database
      final id = await taskService.addTask(name);
      // adding the task name to the local list held in memory
      tasks.add(Task(id: id, name: name, completed: false));
      notifyListeners();
    }
  }

  Future<void> updateTask(int index, bool completed) async {
    // uses array index to find tasks
    final task = tasks[index];
    // update the task collection in the database by id, using bool for completed
    await taskService.updateTask(task.id, completed);
    // updating the local tasks list
    tasks[index] = Task(id: task.id, name: task.name, completed: completed);
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    // uses array index to find the task
    final task = tasks[index];
    // delete the task form the collection
    await taskService.deleteTasks(task.id);

    // remote the task form from the local in memory
    tasks.removeAt(index);
    notifyListeners();
  }
}

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final TextEditingController nameCOntroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Image.asset('assests/rdplogo.png')),
            const Text('Daily Planner'),
          ],
        ),
      ),
    );
  }
}
