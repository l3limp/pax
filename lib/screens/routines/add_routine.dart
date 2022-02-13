import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddRoutine extends StatefulWidget {
  const AddRoutine({Key? key}) : super(key: key);

  @override
  State<AddRoutine> createState() => _AddRoutineState();
}

String routineText = "";
late User? _user;

class _AddRoutineState extends State<AddRoutine> {
  @override
  Widget build(BuildContext context) {
    _user = FirebaseAuth.instance.currentUser;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add Routine",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              letterSpacing: 1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: 20),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                  child: SizedBox(
                    width: width * 0.9,
                    child: TextFormField(
                      onChanged: (text) {
                        routineText = text;
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.redAccent.withOpacity(0.4),
                                width: 2)),
                      ),
                      cursorColor: Colors.redAccent,
                      style: const TextStyle(
                          color: Colors.black, letterSpacing: .5),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  _setRoutine();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                ),
                child: const Text("Add routine"))
          ],
        ),
      ),
    );
  }

  Future _setRoutine() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yMMMd').format(now);
    CollectionReference _posts =
        FirebaseFirestore.instance.collection('routines');
    Navigator.pop(context);
    return _posts
        .doc(_user!.uid)
        .collection('userroutines')
        .doc()
        .set({'text': routineText, 'timestamp': formattedDate});
  }
}
