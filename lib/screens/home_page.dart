import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}

// create a task provider to manange state
class TaskProvider extends ChangeNotifier {}

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
