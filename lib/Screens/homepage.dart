import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'createclassroompage.dart';
import 'package:work_mate/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dbref = FirebaseDatabase.instance.reference().child("class");
  String _clcode;
  String _enteredcode;
  List<String> classlist = [];

  Future<bool> CheckCode(String s) async {
    int _flg = 0;
    await _dbref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == s) {
          _flg = 1;
        }
      });
    });
    //print(_flg);
    if (_flg == 1)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        //backgroundColor: Colors.blue,
        title: Text("Homepage"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/createclassroompage');
                      },
                      child: Text("Create a New Class"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _enteredcode = value;
                      },
                      decoration:
                      InputDecoration(hintText: "Join Class as Student..."),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        bool found =
                        await Future.value(CheckCode(_enteredcode));
                        if (found == true) {
                          Navigator.of(context).pushNamed('/classroompage');
                        } else {
                          print("Class Does Not Exist");
                        }
                      },
                      child: Text("Enter"))
                ],
              ),
              // TextField(
              //   decoration:
              //       InputDecoration(hintText: "Join Class as Faculty..."),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
