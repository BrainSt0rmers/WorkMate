import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classroompage.dart';

class CreateClassRoom extends StatefulWidget {
  @override
  _CreateClassRoomState createState() => _CreateClassRoomState();
}

class _CreateClassRoomState extends State<CreateClassRoom> {
  final _databaseReference = FirebaseDatabase.instance.reference();
  String curracmail;
  String clcode;
  String clname;

  String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  Random _rnd = Random();

  Future<String> getMailID() async {
    String x;
    String user = await FirebaseAuth.instance.currentUser.email;
    return user;
  }

  void curMail() {
    getMailID().then((value) {
      curracmail = value;
      curracmail = curracmail.replaceAll('.', ',');
    });
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Classroom"),
        actions: [
          MaterialButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  clname = value;
                },
                decoration: InputDecoration(hintText: "Enter the Class Name"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await curMail();
                  clcode = getRandomString(8);
                  _databaseReference
                      .child("class/$clcode")
                      .set({"classname": clname});
                  _databaseReference
                      .child("user/$curracmail/classcode")
                      .set({"code": clcode});
                  _databaseReference
                      .child('user/$curracmail')
                      .update({'designation': 'cr'});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClassRoom()));
                },
                child: Text("Generate Class Code"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
