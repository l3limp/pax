import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
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
          appBar: AppBar(
            title: const Text("post"),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("task: " + arguments['task']),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                    child: SizedBox(
                        width: width * 0.9,
                        height: height * 0.2,
                        child: image != null
                            ? Image.file(image!)
                            : const SizedBox()),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.05, 10, width * 0.05, 25),
                    child: SizedBox(
                      width: width * 0.9,
                      height: height * 0.2,
                      child: TextFormField(
                        onChanged: (text) {
                          postText = text;
                        },
                        maxLines: 21,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(color: _theme.secondaryColor),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: _theme.primaryColor)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: showName,
                          onChanged: (value) {
                            showName = value!;
                            setState(() {});
                          }),
                      const Text("post anonymously?"),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        imageLocation = await uploadPic();
                      },
                      child: const Text("upload image")),
                  ElevatedButton(
                      onPressed: () async {
                        if (postText.isNotEmpty) {
                          await Future.delayed(const Duration(seconds: 2));
                          _setPost();
                          Navigator.popAndPushNamed(context, '/posts');
                        } else {
                          const snackBar =
                              SnackBar(content: Text('Post cannot be empty'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text("post")),
                ],
              ),
            ),
          )),
    );
  }

  Future<String> uploadPic() async {
    //Get the file from the image picker and store it
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

    // Waits till the file is uploaded then stores the download url
    String url = await firebase_storage.FirebaseStorage.instance
        .ref('uploads')
        .child(num.toString() + ".png")
        .getDownloadURL();

    //returns the download url
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
