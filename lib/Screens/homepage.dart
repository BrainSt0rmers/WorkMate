import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_mate/Screens/classroompage.dart';
import 'package:work_mate/Screens/joinclasspage.dart';
import 'package:work_mate/Screens/facultyhomepage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getValue() async {
    String s;
    String curmail = await FirebaseAuth.instance.currentUser.email;
    curmail = curmail.replaceAll('.', ',');
    final _dbref = FirebaseDatabase.instance
        .reference()
        .child("user/$curmail/designation");
    await _dbref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values['code']);
      if (values['code'] == 'null' && values['post'] == 'student') {
        s = "studentwithoutclass";
      } else if (values['code'] != 'null' &&
          (values['post'] == 'student' || values['post'] == 'cr')) {
        s = "studentwithclass";
      } else if (values['code'] == 'null' && values['post'] == 'faculty') {
        s = "faculty";
      }
    });
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getValue(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'studentwithoutclass') {
              return JoinClass();
            } else if (snapshot.data == 'studentwithclass') {
              return ClassRoom();
            } else if (snapshot.data == 'faculty') {
              return FacultyHome();
            }
          }
          return Scaffold(
            body: Center(
              child: Text("Entering the class..."),
            ),
          );
        });
  }
}
