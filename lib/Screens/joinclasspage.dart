import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:work_mate/main.dart';

class JoinClass extends StatefulWidget {
  @override
  _JoinClassState createState() => _JoinClassState();
}

class _JoinClassState extends State<JoinClass> {
  String _clcode;
  String _enteredcode;
  List<String> classlist = [];

  Future<bool> _checkCode(String s) async {
    int _flg = 0;
    final dbref1 = FirebaseDatabase.instance.reference().child("class");
    await dbref1.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == s) {
          _flg = 1;
        }
      });
    });
    if (_flg == 1) {
      String curmail = await FirebaseAuth.instance.currentUser.email;
      curmail = curmail.replaceAll('.', ',');
      final dbref2 = FirebaseDatabase.instance
          .reference()
          .child('user/$curmail/designation');
      dbref2.update({'code': s});

      String curpost;
      await dbref2.once().then((DataSnapshot snap) {
        Map<dynamic, dynamic> values = snap.value;
        curpost = values['post'];
      });

      if (curpost == 'student') {
        final dbref3 =
            await FirebaseDatabase.instance.reference().child('user/$curmail');
        dbref3.update({
          'ccode': {_enteredcode: '-'}
        });

        String rno;
        String name;
        dbref3.once().then((DataSnapshot s) {
          Map<dynamic, dynamic> v = s.value;
          rno = v['rollno'];
          name = v['name'];
        });

        final dbref4 = await FirebaseDatabase.instance
            .reference()
            .child('class/$_enteredcode/studlist');
        await dbref4.once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> val = snap.value;
          val[curmail] = ({'rollno': rno, 'name': name});
          dbref4.set(val);
        });

        List<dynamic> sublist = [];
        await FirebaseDatabase.instance
            .reference()
            .child('class/$_enteredcode/subject')
            .once()
            .then((DataSnapshot snap) {
          Map<dynamic, dynamic> val = snap.value;
          for (var i in val.entries) {
            sublist.add(i.key);
          }
        });
        final dbref5 = await FirebaseDatabase.instance
            .reference()
            .child('user/$curmail/ccode');
        await dbref5.once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> values = snap.value;
          for (var i in sublist) {
            values[i] = ({'numofattended': 0, 'numofclasses': 0});
          }
          dbref5.set(values);
        });
      } else if (curpost == 'faculty') {
        final dbref6 = await FirebaseDatabase.instance
            .reference()
            .child('user/$curmail/ccode');
        dbref6.once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> val = snap.value;
          val[_enteredcode] = '-';
          dbref6.set(val);
        });
      }
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text(
                "Sign Out",
                //style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
        //backgroundColor: Colors.blue,
        title: Text("Join Class"),
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: TextField(
                        onChanged: (value) {
                          _enteredcode = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter the Class Code..."),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        bool found =
                            await Future.value(_checkCode(_enteredcode));
                        if (found == true) {
                          cd.curclass = _enteredcode;
                          Navigator.of(context).pushNamed('/classroompage');
                        } else {
                          print("Class Does Not Exist");
                        }
                        return Scaffold(
                          body: Center(
                            child: Text("Entering the class..."),
                          ),
                        );
                      },
                      child: Text("Enter"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
