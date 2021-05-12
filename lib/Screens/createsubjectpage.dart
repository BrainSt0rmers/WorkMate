import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:work_mate/main.dart';

class CreateSubject extends StatefulWidget {
  @override
  _CreateSubjectState createState() => _CreateSubjectState();
}

class _CreateSubjectState extends State<CreateSubject> {
  String subcode;
  String subname;
  String gencode;
  String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> saveEnteredData() async {
    gencode = getRandomString(8);
    String curmail = await FirebaseAuth.instance.currentUser.email;
    curmail = curmail.replaceAll('.', ',');
    String curclass;
    final dbref1 =
        FirebaseDatabase.instance.reference().child("user/$curmail/ccode");
    await dbref1.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, val) {
        if (val == '-') {
          curclass = key;
        }
      });
    });
    final dbref2 =
        FirebaseDatabase.instance.reference().child("user/$curmail/ccode");
    dbref2.child('/$gencode').set({'numofattended': 0, 'numofclasses': 0});
    final dbref3 =
        FirebaseDatabase.instance.reference().child("class/$curclass");
    dbref3
        .child('subject/$gencode')
        .set({'subcode': '$subcode', 'subname': '$subname'});
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () async {
                await auth.signOut();
              },
              child: Text(
                "Sign Out",
                //style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
        title: Text("Create Subject Page"),
        //backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                subcode = value;
              },
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(hintText: "Enter Subject Code..."),
            ),
            TextField(
              onChanged: (value) {
                subname = value;
              },
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(hintText: "Enter Subject Name..."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Generate Subject Code"),
                  onPressed: () async {
                    await saveEnteredData();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/landingpage', (Route<dynamic> route) => false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
