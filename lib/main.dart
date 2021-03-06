import 'package:flutter/material.dart';
import 'package:pax/init/initialisation.dart';
import 'package:pax/screens/fitness.dart';
import 'package:pax/screens/home.dart';
import 'package:pax/screens/init.dart';
import 'package:pax/screens/login.dart';
import 'package:pax/screens/main_home.dart';
import 'package:pax/screens/posts/posts.dart';
import 'package:pax/screens/routines/add_routine.dart';
import 'package:pax/screens/routines/routines.dart';
import 'package:pax/screens/tasks/task_page.dart';
import 'package:pax/screens/tasks/write_post.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: Colors.white,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/init': (context) => const Initialising(),
        '/home': (context) => const MainHome(),
        '/login_page': (context) => const LoginPage(),
        '/task_page': (context) => const TasksPage(),
        '/write_post': (context) => const WritePost(),
        '/posts': (context) => const PostsPage(),
        '/routines': (context) => const Routines(),
        '/addroutine': (context) => const AddRoutine(),
        '/fitness': (context) => const FitnessPage(),
        '/': (context) => const SplashScreen(),
      },
    ),
  );
}
