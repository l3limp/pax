import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckBoxList extends StatefulWidget {
  final String routine;
  final String date;
  final String documentID;
  const CheckBoxList(
      {Key? key,
      required this.routine,
      required this.date,
      required this.documentID})
      : super(key: key);

  @override
  _CheckBoxListState createState() => _CheckBoxListState();
}

late User? _user;

class _CheckBoxListState extends State<CheckBoxList> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    _user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 2, offset: Offset(1.5, 3)),
        ], borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        child: Theme(
          data: ThemeData(unselectedWidgetColor: const Color(0xFFFF585c)),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              widget.routine,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            subtitle: Text(
              widget.date,
              style: const TextStyle(color: Colors.black),
            ),
            activeColor: Colors.green,
            checkColor: Colors.white,
            autofocus: false,
            value: _value,
            // selected: _value,
            onChanged: (bool? value) {
              CollectionReference userRoutines = FirebaseFirestore.instance
                  .collection('routines')
                  .doc(_user!.uid)
                  .collection('userroutines');
              deleteRoutine(userRoutines);
            },
          ),
        ),
      ),
    );
  }

  Future<void> deleteRoutine(CollectionReference userRoutine) {
    return userRoutine.doc(widget.documentID).delete().then((value) => null);
  }
}
