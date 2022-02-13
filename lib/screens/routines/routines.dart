import 'package:flutter/material.dart';
import 'package:pax/screens/routines/checkboxlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Routines extends StatefulWidget {
  const Routines({Key? key}) : super(key: key);

  @override
  _RoutinesState createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines> {
  late CollectionReference users;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late Stream<QuerySnapshot> _routinesStream;
  @override
  Widget build(BuildContext context) {
    _user = _auth.currentUser;
    users = FirebaseFirestore.instance.collection('users');
    _routinesStream = FirebaseFirestore.instance
        .collection('routines')
        .doc(_user!.uid)
        .collection('userroutines')
        .snapshots();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addroutine');
        },
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Routines"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _routinesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: getRoutines(snapshot),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  getRoutines(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      return CheckBoxList(routine: data['text'], date: data['timestamp'], documentID: document.id,);
    }).toList();
  }
}
