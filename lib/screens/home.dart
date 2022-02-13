import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pax/objects/tasks.dart';
import 'package:pax/screens/posts/posts.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text("Logo!", style: TextStyle(color: Colors.black)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: InkWell(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, '/login_page');
                },
                child: Container(
                  width: _width * 0.22,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xFFFF585C),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                setTask();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back,",
                        style: TextStyle(color: Colors.black, fontSize: 22.0),
                      ),
                      Text(
                        _user!.email!.split("@")[0],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/task_page',
                              arguments: {
                                'taskNumber': snapshot.data!['taskNumber']
                              });
                        },
                        child: Center(
                          child: Container(
                            width: _width * 0.9,
                            height: _height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFFFE8180)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Center(
                          child: Container(
                            width: _width * 0.9,
                            height: _height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFF64A4DA)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Center(
                          child: Container(
                            width: _width * 0.9,
                            height: _height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFFE76A40)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/routines');
                        },
                        child: Center(
                          child: Container(
                            width: _width * 0.9,
                            height: _height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFF8F98FD)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return CircularProgressIndicator(
                color: _theme.secondaryColor,
              );
            }),
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
