import 'package:flutter/material.dart';
import 'package:pax/objects/google_links.dart';
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

class _TasksPageState extends State<TasksPage> {
  final _theme = OurTheme();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
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
                  arguments['task'],
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
                child: const Center(
                  child: Text(
                    "Sample image about the acivity will come here",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
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
                      if (!await launch(
                          _youtubeVids.videoList[arguments['taskNumber']])) {
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
                      if (!await launch(
                          _googleLinks.googleLinks[arguments['taskNumber']])) {
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/post_page',
                            arguments: {'task': arguments['task']});
                      },
                      child: const Text("Skip todays activity")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/post_page',
                            arguments: {'task': arguments['task']});
                      },
                      child: const Text("Post your activity")),
                ],
              )
            ],
          ),
        ));
  }
}
