import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pax/screens/posts/card.dart';
import 'package:pax/theme.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late Stream<QuerySnapshot> _postsStream;
  final OurTheme _theme = OurTheme();
  late String docID;
  late int likes;
  final Icon _icon1 = const Icon(
    Icons.mail,
    size: 50,
    color: Colors.amber,
  );
  final Icon _icon2 = const Icon(
    Icons.camera,
    size: 50,
    color: Colors.amber,
  );
  @override
  Widget build(BuildContext context) {
    _postsStream = FirebaseFirestore.instance.collection('posts').snapshots();
    _user = _auth.currentUser;
    return Scaffold(
        backgroundColor: _theme.primaryColor,
        appBar: AppBar(
          // centerTitle: true,
          backgroundColor: _theme.primaryColor,
          title: Text(
            "Posts",
            style: TextStyle(
              color: _theme.secondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: _postsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: getBooks(snapshot),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }

  getBooks(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return Padding(
        padding: const EdgeInsets.only(bottom: 3.0, top: 7.0),
        child: Column(
          children: [
            Text(data['activityName']),
            PostCard(
              activityName: data['activityName'],
              authorName: data['author'],
              postText: data['text'],
              likes: data['likes'],
              showName: data['showName'],
              docID: document.id,
            ),
          ],
        ),
      );
    }).toList();
  }

  increaseLikes(String docID, int likes) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(docID)
        .update({'likes': likes + 1});
  }

  decreaseLikes(String docID, int likes) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(docID)
        .update({'likes': likes - 1});
  }
}
