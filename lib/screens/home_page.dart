import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/providers/task-provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final TextEditingController nameCOntroller =
      TextEditingController(); // this thing to type task name

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).loadTasks(); // load all tasks after page show
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset('assests/rdplogo.png', height: 80),
            ), // show logo pic here
            const Text(
              'Daily Planner', // big text on top
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: TableCalendar(
                calendarFormat: CalendarFormat.month, // this show big calendar
                focusedDay: DateTime.now(), // show today date
                firstDay: DateTime(2025), // first date start
                lastDay: DateTime(2026), // last date end
              ),
            ),
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return buildTaksItem(
                taskProvider.tasks, // all tasks come here
                taskProvider.removeTask, // remove task button
                taskProvider.updateTask, // update when click checkbox
              );
            },
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return buildAddTaskSection(nameCOntroller, () async {
                await taskProvider.addTask(
                  nameCOntroller.text,
                ); // add new task in list
                nameCOntroller.clear(); // clear text box after add
              });
            },
          ),
        ],
      ),
      drawer: Drawer(), // the slide menu thing
    );
  }
}

// Build the section for adding tasks

Widget buildAddTaskSection(nameController, addTask) {
  return Container(
    decoration: BoxDecoration(color: Colors.white), // white box
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: TextField(
              maxLength: 32, // only 32 letters long
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Add Task", // text say add task
                border: OutlineInputBorder(), // box border
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: addTask,
          child: Text('Add Task'),
        ), // click this to add
      ],
    ),
  );
}

Widget buildTaksItem(
  List<Task> tasks,
  Function(int) removeTasks,
  Function(int, bool) updateTask,
) {
  return ListView.builder(
    shrinkWrap: true, // make list small
    physics: const NeverScrollableScrollPhysics(), // no scroll inside
    itemCount: tasks.length, // how many tasks we have
    itemBuilder: (context, index) {
      final task = tasks[index]; // pick task one by one
      final isEven = index % 2 == 0; // check if even number for color

      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // make corner round
          ),
          tileColor: isEven
              ? Colors.blue
              : Colors.green, // blue and green for fun
          leading: Icon(
            task.completed
                ? Icons.check_circle
                : Icons.circle_outlined, // show tick or empty circle
          ),
          title: Text(
            task.name,
            style: TextStyle(
              decoration: task.completed
                  ? TextDecoration.lineThrough
                  : null, // cut text if done
              fontSize: 22,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: task.completed,
                onChanged: (value) => {
                  updateTask(index, value!),
                }, // when tick change task done or not
              ),
              IconButton(
                onPressed: () => removeTasks(index), // click delete to remove
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
    },
  );
}
