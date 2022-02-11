import 'package:flutter/material.dart';
import 'package:pax/init/initialisation.dart';
import 'package:pax/screens/home.dart';
import 'package:pax/screens/login.dart';

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
        '/': (context) => const Initialising(),
        '/home': (context) => const HomeScreen(),
        '/login_page': (context) => const LoginPage(),
      },
    ),
  );
}
