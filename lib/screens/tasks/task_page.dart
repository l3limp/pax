import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

late Map arguments;

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(
          title: const Text("task"),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
              Text(arguments['task']),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/post_page',
                        arguments: {'task': arguments['task']});
                  },
                  child: Text(arguments['task']))
            ],
          )),
        ));
  }
}
