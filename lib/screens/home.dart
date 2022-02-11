import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pax"),
      ),
      body: Center(
          child: TextButton(
        child: Text("pax sign out"),
        onPressed: () async {
          await _auth.signOut();
          Navigator.popAndPushNamed(context, '/login_page');
        },
      )),
    );
  }
}
