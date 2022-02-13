import 'package:flutter/material.dart';
import 'package:pax/screens/routines/checkboxlist.dart';

class Routines extends StatefulWidget {
  const Routines({Key? key}) : super(key: key);

  @override
  _RoutinesState createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines> {
  @override
  Widget build(BuildContext context) {
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
      body: const CheckBoxList(),
    );
  }
}
