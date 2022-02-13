import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WritePost extends StatefulWidget {
  const WritePost({Key? key}) : super(key: key);

  @override
  _WritePostState createState() => _WritePostState();
}

late Map arguments;
late User? _user;
String postText = "";
bool showName = false;
String imageLocation = "a";
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class _WritePostState extends State<WritePost> {
  File? image;
  @override
  Widget build(BuildContext context) {
    _user = FirebaseAuth.instance.currentUser;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "Create a post",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                  letterSpacing: 1),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: height - 100,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      arguments['task'],
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                    child: image != null
                        ? SizedBox(
                            width: width * 0.9,
                            height: height * 0.2,
                            child: Image.file(image!))
                        : const SizedBox(),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                    child: SizedBox(
                      width: width * 0.9,
                      height: height * 0.25,
                      child: TextFormField(
                        onChanged: (text) {
                          postText = text;
                        },
                        maxLines: 21,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.redAccent.withOpacity(0.4),
                                  width: 2)),
                        ),
                        cursorColor: Colors.redAccent,
                        style: const TextStyle(
                            color: Colors.black, letterSpacing: .5),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.redAccent,
                        ),
                        child: Checkbox(
                            value: showName,
                            checkColor: Colors.white,
                            activeColor: Colors.redAccent,
                            onChanged: (value) {
                              showName = value!;
                              setState(() {});
                            }),
                      ),
                      const Text(
                        "Post anonymously?",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          imageLocation = await uploadPic();
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Colors.redAccent),
                        child: const Text("Upload image"),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                          ),
                          onPressed: () async {
                            if (postText.isNotEmpty) {
                              await Future.delayed(const Duration(seconds: 2));
                              _setPost();
                              Navigator.popAndPushNamed(context, '/posts');
                            } else {
                              const snackBar = SnackBar(
                                  content: Text('Post cannot be empty'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text("       Post        "))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<String> uploadPic() async {
    Random _random = Random();
    int num = _random.nextInt(99999);
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageTemp = File(image!.path);
    setState(() {
      this.image = imageTemp;
    });

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads')
          .child(num.toString() + ".png")
          .putFile(imageTemp);
    } on FirebaseException catch (e) {
      print(e);
    }

    String url = await firebase_storage.FirebaseStorage.instance
        .ref('uploads')
        .child(num.toString() + ".png")
        .getDownloadURL();

    return url;
  }

  Future<void> _setPost() {
    CollectionReference _posts = FirebaseFirestore.instance.collection('posts');
    final email = _user!.email.toString().split('@');
    return _posts.doc().set({
      'text': postText,
      'timestamp': Timestamp.now(),
      'author': email[0],
      'activityName': arguments['task'],
      'showName': showName,
      'likes': 0,
      'uid': _user!.uid,
      'image': imageLocation
    });
  }
}
