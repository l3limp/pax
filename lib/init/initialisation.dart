import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pax/screens/home.dart';
import 'package:pax/screens/login.dart';

class Initialising extends StatefulWidget {
  const Initialising({Key? key}) : super(key: key);

  @override
  _InitialisingState createState() => _InitialisingState();
}

class _InitialisingState extends State<Initialising> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    User? _user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                _user = _auth.currentUser;
                if (_user != null) {
                  return const HomeScreen();
                } else {
                  return const LoginPage();
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
