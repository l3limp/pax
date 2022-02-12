import 'dart:math';

import 'package:intl/intl.dart';
import 'package:pax/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

late FirebaseAuth _firebaseAuth;
late CollectionReference users;
late String _email;
late String _password;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _firebaseAuth = FirebaseAuth.instance;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    OurTheme _theme = OurTheme();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: Container(
          height: height,
          width: width,
          child: Row(
            children: [
              Container(
                  height: height,
                  width: width * 0.6,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.0772,
                        ),
                        SizedBox(
                          height: height * 0.15,
                          width: width * 0.4,
                          child: Center(
                            child: Text("PAX",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: _theme.primaryColor,
                                      letterSpacing: .5,
                                      fontSize: 30),
                                )),
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: TextFormField(
                            onChanged: (text) {
                              _email = text;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Email",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: _theme.secondaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: _theme.primaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _theme.secondaryColor,
                                      width: 1.3)),
                            ),
                            cursorColor: _theme.secondaryColor,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: _theme.primaryColor,
                                  letterSpacing: .5),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width * 0.5,
                          child: TextField(
                            onChanged: (text) {
                              _password = text;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Password",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: _theme.secondaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: _theme.primaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _theme.secondaryColor,
                                      width: 1.3)),
                            ),
                            cursorColor: _theme.secondaryColor,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: _theme.primaryColor,
                                  letterSpacing: .5),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        InkWell(
                          onTap: () {
                            if (_password.length < 7) {
                              const snackBar = SnackBar(
                                  content: Text(
                                      'Please choose a password with more than 6 characters'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              _signInOrSignUp(context, _email, _password);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: _theme.primaryColor,
                                      blurRadius: 2,
                                      offset: const Offset(1, 2)),
                                ],
                                border: Border.all(
                                    color: _theme.primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: width * 0.5,
                              height: 60,
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: _theme.primaryColor,
                                        letterSpacing: .5),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  )),
              Container(
                  height: height,
                  width: width * 0.2,
                  color: _theme.secondaryColor),
              Container(
                  height: height,
                  width: width * 0.2,
                  color: _theme.primaryColor),
            ],
          ),
        )),
      ),
    );
  }

  void _signInOrSignUp(
      BuildContext _context, String emailID, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailID, password: password);
      users = FirebaseFirestore.instance.collection('users');
      print('New user created.');
      createUser(password);
      Navigator.popAndPushNamed(_context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        try {
          await _firebaseAuth.signInWithEmailAndPassword(
              email: emailID, password: password);
          Navigator.popAndPushNamed(_context, '/home');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(String password) {
    Random _random = Random();
    return users
        .doc(_firebaseAuth.currentUser!.uid)
        .set({
          'taskNumber': _random.nextInt(6),
          'taskDate': DateFormat('EEEEE', 'en_US').format(DateTime.now()),
          'emailID': _firebaseAuth.currentUser!.email.toString(),
          'password': password,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
