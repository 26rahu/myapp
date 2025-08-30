class Task {
  final String id; // this is like task number so we know which one
  final String name; // name of the task, like "do homework"
  final bool completed; // true if done, false if nope

  Task({required this.id, required this.name, required this.completed}); // make new task with id name done or not

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id, // put id here
      name: data["name"] ?? "", // if name missing then empty
      completed: data["completed"] ?? false, // if no completed info then false
    );
  }
}
