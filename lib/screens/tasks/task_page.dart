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
late FirebaseAuth _auth = FirebaseAuth.instance;
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

  final _theme = OurTheme();
  @override
  Widget build(BuildContext context) {
    _auth = FirebaseAuth.instance;
    _user = FirebaseAuth.instance.currentUser;
    users = FirebaseFirestore.instance.collection('users');
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    taskNumber = tasknumberchecker ? taskNumber : arguments['taskNumber'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            "Your Today's Activity",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
                fontFamily: _theme.font,
                letterSpacing: 1.2),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: _width * 0.9,
                child: Text(
                  _tasks.tasksList[taskNumber],
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: _theme.font,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                ),
              ),
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
                child: const Text(
                  "Here some brief description about the activity will come\nBla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla",
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      if (!await launch(_youtubeVids.videoList[taskNumber])) {
                        throw 'Could not launch URL';
                      }
                    },
                    child: const Text(
                      'Click to see YT video',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (!await launch(_googleLinks.googleLinks[taskNumber])) {
                        throw 'Could not launch URL';
                      }
                    },
                    child: const Text(
                      'Click to see loactions near you',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        int number = _random.nextInt(6);
                        await setTask(number);
                        updateScreen(number);
                      },
                      child: const Text("Skip todays activity")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/post_page',
                            arguments: {'task': _tasks.tasksList[taskNumber]});
                      },
                      child: const Text("Post your activity")),
                ],
              )
            ],
          ),
        ));
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
