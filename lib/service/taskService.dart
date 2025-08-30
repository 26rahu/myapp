import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/task.dart';

// this thing talks to the cloud (firestore) and do task stuff
class TaskService {
  // this is like my cloud door key
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // get all tasks from the cloud
  Future<List<Task>> fetchTask() async {
    // ask cloud for all tasks sorted by time so old ones first
    final snapshot = await db.collection('tasks').orderBy('timestamp').get();

    // turn all the cloud data into Task objects so app can use
    return snapshot.docs
        .map(
          (doc) => Task.fromMap(doc.id, doc.data()),
        ) // make each doc into Task
        .toList(); // put them in a list
  }

  // add a new task to cloud
  Future<String> addTask(String name) async {
    final newTask = {
      'name': name, // task name we type
      'completed': false, // new task is not done yet duh
      'timestamp': FieldValue.serverTimestamp(), // when we add it (cloud time)
    };

    final docRef = await db.collection('tasks').add(newTask); // send to cloud

    return docRef.id; // give back id number from cloud
  }

  // change a task done or not
  Future<void> updateTask(String id, bool completed) async {
    await db.collection('tasks').doc(id).update({
      'completed': completed,
    }); // tell cloud if done
  }

  // delete the task from cloud (bye bye)
  Future<void> deleteTasks(String id) async {
    await db.collection('tasks').doc(id).delete(); // remove it forever
  }
}
