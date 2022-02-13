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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a routine"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              autofocus: true,
              cursorColor: Colors.redAccent,
              onChanged: (value) {
                routineText = value;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  print(routineText);
                  _setRoutine();
                },
                child: const Text("Add the routine"))
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
    return _posts
        .doc(_user!.uid)
        .collection('userroutines')
        .doc()
        .set({'text': routineText, 'timestamp': formattedDate});
  }
}
