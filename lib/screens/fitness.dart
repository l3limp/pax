import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class FitnessPage extends StatefulWidget {
  const FitnessPage({Key? key}) : super(key: key);

  @override
  _FitnessPageState createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  @override
  void initState() {
    super.initState();
    callAPI();
  }

  static String key = 'AIzaSyDRNZto4IJUDroHRi1F-v8oNj0r4wMDjz0';
  YoutubeAPI youtube = YoutubeAPI(key, maxResults: 25);
  List<YouTubeVideo> videoResult = [];

  String query = "Motivation Fitness";

  List videoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Daily Dose of Fitness",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              letterSpacing: 1.2),
        ),
      ),
      body: ListView(
        children: videoResult.map<Widget>(listItem).toList(),
      ),
    );
  }

  Future<void> callAPI() async {
    String query = "Motivational Fitness";
    videoResult = await youtube.search(
      query,
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  Widget listItem(YouTubeVideo video) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, blurRadius: 2, offset: Offset(1, 2)),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7.0),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.network(
                  video.thumbnail.small.url ?? '',
                  width: 120.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title.toString().substring(0, 25) + "...",
                      softWrap: true,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        video.channelTitle,
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Linkify(
                      onOpen: (link) async {
                        if (!await launch(link.url)) {
                          throw 'Could not launch ${link.url}';
                        }
                      },
                      text: video.url,
                      style: const TextStyle(color: Colors.black),
                      linkStyle: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
