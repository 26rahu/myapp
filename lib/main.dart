import 'package:flutter/material.dart';
import 'package:myapp/providers/task-provider.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // make flutter ready before start

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // start firebase magic stuff

  runApp(const MyApp()); // run my cool app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(), // this give tasks to everyone in app
      child: const MaterialApp(home: Home_Page()), // show home page first
    );
  }
}
