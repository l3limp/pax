import 'package:flutter/material.dart';

class CheckBoxList extends StatefulWidget {
  const CheckBoxList({Key? key}) : super(key: key);

  @override
  _CheckBoxListState createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.black),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              "This is a checkbox",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              "This is a subtitle for the checkbox",
              style: TextStyle(color: Colors.black),
            ),
            activeColor: Colors.green,
            checkColor: Colors.white,
            autofocus: false,
            value: _value,
            selected: _value,
            onChanged: (bool? value) {
              setState(() {
                _value = !_value;
              });
            },
          ),
        ),
      ),
    );
  }
}
