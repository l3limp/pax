import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pax/objects/google_links.dart';
import 'package:pax/objects/tasks.dart';
import 'package:pax/objects/youtube_vids.dart';
import 'package:pax/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

late Map arguments;
YoutubeVids _youtubeVids = YoutubeVids();
GoogleLinks _googleLinks = GoogleLinks();
Tasks _tasks = Tasks();
late CollectionReference users;
late User? _user;
Random _random = Random();
late int taskNumber;
bool tasknumberchecker = false;

class _TasksPageState extends State<TasksPage> {
  updateScreen(int number) {
    setState(() {
      taskNumber = number;
      tasknumberchecker = !tasknumberchecker;
    });
  }

  @override
  Widget build(BuildContext context) {
    _user = FirebaseAuth.instance.currentUser;
    users = FirebaseFirestore.instance.collection('users');
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    taskNumber = tasknumberchecker ? taskNumber : arguments['taskNumber'];
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              "Activity of the Day",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                  letterSpacing: 1.2),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: InkWell(
                  onTap: () async {
                    int number = _random.nextInt(9);
                    await setTask(number);
                    updateScreen(number);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF585c),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Skip",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ],
                    ),
                    width: _width * 0.19,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[800]),
                  height: _height * 0.35,
                  width: _width * 0.95,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      "assets/images/$taskNumber.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: _width * 0.9,
                  child: Text(
                    _tasks.tasksList[taskNumber],
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        fontSize: 27.0),
                  ),
                ),
                SizedBox(
                  width: _width * 0.9,
                  child: Text(
                    _tasks.tasksDescription[taskNumber],
                    style: const TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      if (!await launch(_googleLinks.googleLinks[taskNumber])) {
                        throw 'Could not launch URL';
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFFF585C),
                        ),
                        Text(
                          'Click to see loactions near you',
                          style: TextStyle(
                              color: Color(0xFFFF585C),
                              fontSize: 17.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!await launch(_youtubeVids.videoList[taskNumber])) {
                          throw 'Could not launch URL';
                        }
                      },
                      child: Container(
                        width: _width * 0.4,
                        height: _height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFFFF585C),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.desktop_mac_rounded,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            Text(
                              "Watch Demo",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, '/write_post',
                            arguments: {'task': _tasks.tasksList[taskNumber]});
                      },
                      child: Container(
                        width: _width * 0.4,
                        height: _height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFFFF585C),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.add_circle_rounded,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            Text(
                              "Add Post",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Future<void> setTask(int number) async {
    await users.doc(_user!.uid).get().then((value) async {
      await users.doc(_user!.uid).update({
        'taskNumber': number,
        'taskDate': DateFormat('EEEEE', 'en_US').format(DateTime.now())
      });
    });
  }
}
