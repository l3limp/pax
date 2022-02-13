import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pax/screens/posts/card.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Stream<QuerySnapshot> _postsStream;
  late String docID;
  late int likes;
  @override
  Widget build(BuildContext context) {
    _postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: false)
        .snapshots();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.red,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Community",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox(
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
        padding: const EdgeInsets.fromLTRB(20, 17, 20, 3),
        child: PostCard(
          activityName: data['activityName'],
          authorName: data['author'],
          postText: data['text'],
          likes: data['likes'],
          showName: data['showName'],
          docID: document.id,
          image: data['image'],
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
