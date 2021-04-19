import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

class ClassRoom extends StatefulWidget {
  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.of(context).pop();
            },
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text("Class Page"),
      ),
    );
  }
}
