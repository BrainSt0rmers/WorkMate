import 'dart:math';

import 'package:flutter/material.dart';
import 'homepage.dart';

class CreateClassRoom extends StatefulWidget {
  @override
  _CreateClassRoomState createState() => _CreateClassRoomState();
}

class _CreateClassRoomState extends State<CreateClassRoom> {
  String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Classroom"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Enter the Class Name"),
              ),
              ElevatedButton(
                onPressed: () {
                  print(getRandomString(8));
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