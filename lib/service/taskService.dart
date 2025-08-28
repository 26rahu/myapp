import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/task.dart';

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
