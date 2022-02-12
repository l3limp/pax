import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pax/objects/tasks.dart';
import 'package:pax/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

OurTheme _theme = OurTheme();
late CollectionReference users;
late FirebaseAuth _auth = FirebaseAuth.instance;
late User? _user;
Tasks _tasks = Tasks();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    _auth = FirebaseAuth.instance;
    _user = FirebaseAuth.instance.currentUser;
    users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: Text("Pax"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Container(
              child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    setTask();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _theme.secondaryColor,
                              )),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/task_page', arguments: {
                                  'task': _tasks
                                      .tasksList[snapshot.data!['taskNumber']]
                                });
                              },
                              child: Text(_tasks
                                  .tasksList[snapshot.data!['taskNumber']]))),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: _theme.secondaryColor,
                    ),
                  );
                },
              ),
            )),
            TextButton(
              child: Text("pax sign out"),
              onPressed: () async {
                await _auth.signOut();
                Navigator.popAndPushNamed(context, '/login_page');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setTask() async {
    Random _random = Random();
    await users.doc(_user!.uid).get().then((value) async {
      if (value['taskNumber'].toString().isEmpty ||
          value['taskDate'] !=
              DateFormat('EEEEE', 'en_US').format(DateTime.now())) {
        await users.doc(_user!.uid).update({
          'taskNumber': _random.nextInt(6),
          'taskDate': DateFormat('EEEEE', 'en_US').format(DateTime.now())
        });
      }
    });
  }

  Future<void> getTask() async {
    int _taskNumber = 0;
    await users.doc(_user!.uid).get().then((value) async {
      if (value['taskNumber'].toString().isNotEmpty) {
        _taskNumber = value['taskNumber'];
      }
    });
  }
}
