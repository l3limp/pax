import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pax/theme.dart';

class WritePost extends StatefulWidget {
  const WritePost({Key? key}) : super(key: key);

  @override
  _WritePostState createState() => _WritePostState();
}

late Map arguments;
OurTheme _theme = OurTheme();
late User? _user;
String postText = "";

class _WritePostState extends State<WritePost> {
  @override
  Widget build(BuildContext context) {
    _user = FirebaseAuth.instance.currentUser;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("post"),
          ),
          body: Center(
            child: Container(
                child: Column(
              children: [
                Text("task: " + arguments['task']),
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.4,
                    child: TextFormField(
                      initialValue: arguments['address'],
                      onChanged: (text) {
                        postText = text;
                      },
                      maxLines: 21,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(color: _theme.secondaryColor),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _theme.primaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _theme.secondaryColor, width: 2)),
                      ),
                      cursorColor: _theme.secondaryColor,
                      style: TextStyle(
                            color: _theme.primaryColor, letterSpacing: .5),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (postText.isNotEmpty) {
                        _setPost();
                      } else {
                        const snackBar =
                            SnackBar(content: Text('Post cannot be empty'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text("post"))
              ],
            )),
          )),
    );
  }

  Future<void> _setPost() {
    CollectionReference _posts = FirebaseFirestore.instance.collection('posts');
    print("post set");
    return _posts.doc().set(
        {'text': postText, 'timestamp': Timestamp.now(), 'uid': _user!.uid});
  }
}
