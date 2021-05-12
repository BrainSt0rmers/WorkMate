import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:work_mate/main.dart';

class FacultyJoin extends StatefulWidget {
  @override
  _FacultyJoinState createState() => _FacultyJoinState();
}

class _FacultyJoinState extends State<FacultyJoin> {
  String enteredcode;

  Future<bool> _checkCode(String s) async {
    int _flg = 0;
    //print(cd.curclass);
    if (cd.curclass == null) {
      print('Account Not Faculty');
    } else {
      String curclass = cd.curclass;
      final dbref1 = FirebaseDatabase.instance
          .reference()
          .child("class/$curclass/subject");
      await dbref1.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          if (key == s) {
            _flg = 1;
          }
        });
      });
    }
    if (_flg == 1) {
      String curmail = await FirebaseAuth.instance.currentUser.email;
      curmail = curmail.replaceAll('.', ',');

      String curpost;
      await FirebaseDatabase.instance
          .reference()
          .child('user/$curmail/designation')
          .once()
          .then((DataSnapshot snap) {
        Map<dynamic, dynamic> values = snap.value;
        curpost = values['post'];
      });
      if (curpost == 'student' || curpost == 'cr') {
        await FirebaseDatabase.instance
            .reference()
            .child('user/$curmail/ccode')
            .set({'${cd.curclass}': '$enteredcode'});

        final dbref3 = FirebaseDatabase.instance.reference();
        dbref3
            .child('user/$curmail/designation')
            .set({'code': 'null', 'post': 'faculty'});

        dbref3.child('class/${cd.curclass}/studlist/$curmail').remove();
      } else if (curpost == 'faculty') {
        final dbref4 = await FirebaseDatabase.instance
            .reference()
            .child('user/$curmail/ccode');
        await dbref4.once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> values = snap.value;
          values[cd.curclass] = enteredcode;
          dbref4.set(values);
        });
        await FirebaseDatabase.instance
            .reference()
            .child('user/$curmail/designation')
            .set({'code': 'null', 'post': 'faculty'});
      }
      return true;
    } else
      return false;
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/landingpage', (Route<dynamic> route) => false);
              },
              child: Text(
                "Sign Out",
                //style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
        title: Text("Faculty Join Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Subject Code...",
              ),
              onChanged: (value) {
                enteredcode = value;
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    bool found = await _checkCode(enteredcode);
                    if (found == true) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/landingpage', (Route<dynamic> route) => false);
                    } else {
                      print('Subject not found');
                    }
                  },
                )
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
