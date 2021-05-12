import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_mate/main.dart';

class ManageAttendance extends StatefulWidget {
  @override
  _ManageAttendanceState createState() => _ManageAttendanceState();
}

class _ManageAttendanceState extends State<ManageAttendance> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> studmaillist = [];
  List<dynamic> studlist = [];
  List<dynamic> icon = [];
  bool flg = false;
  List<MaterialStateProperty<Color>> butclr = [];

  Future<String> getStud() async {
    if (flg == false) {
      await doWork();
      String x = 'Done';
      flg = true;
      return x;
    } else {
      String x = 'DoneBeforeItself';
      return x;
    }
  }

  Future<void> doWork() async {
    final dbref1 = await FirebaseDatabase.instance
        .reference()
        .child('class/${cd.curclass}/studlist')
        .once();

    studmaillist.clear();
    studlist.clear();
    Map<dynamic, dynamic> values = dbref1.value;
    values.forEach((key, val) {
      studmaillist.add(key);
      studlist.add(val);
      icon.add(Icons.close);
      butclr.add(MaterialStateProperty.all(Color(0xFFB00020)));
    });
  }

  Future<void> updateAttendDB() async {
    final dbref = FirebaseDatabase.instance.reference();
    for (int i = 0; i < studmaillist.length; i++) {
      if (icon[i] == Icons.done) {
        await dbref
            .child('user/${studmaillist[i]}/ccode/${cd.cursub}')
            .once()
            .then((DataSnapshot snap) {
          Map<dynamic, dynamic> values = snap.value;
          values['numofattended'] += 1;
          values['numofclasses'] += 1;
          dbref.child('user/${studmaillist[i]}/ccode/${cd.cursub}').set(values);
        });
      } else if (icon[i] == Icons.close) {
        await dbref
            .child('user/${studmaillist[i]}/ccode/${cd.cursub}')
            .once()
            .then((DataSnapshot snap) {
          Map<dynamic, dynamic> values = snap.value;
          values['numofclasses'] += 1;
          dbref.child('user/${studmaillist[i]}/ccode/${cd.cursub}').set(values);
        });
      }
    }
  }

  MaterialStateProperty<Color> setButtonColor(Color x, int i) {
    butclr[i] = MaterialStateProperty.all(x);
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
        title: Text("Manage Attendance"),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 34, top: 8, bottom: 8),
            child: Row(
              children: [Text('Students'), Spacer(), Text('Status')],
            ),
          ),
          FutureBuilder(
              future: getStud(),
              builder: (context, snapshot) {
                // if (flg == false) {
                //   for (int i = 0; i < studlist.length; i++) {
                //     icon.add(Icons.close);
                //   }
                // }
                //print(icon);
                if (snapshot.hasData) {
                  return Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.grey.shade900,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new ListView.builder(
                              shrinkWrap: true,
                              itemCount: studlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Student Name: "),
                                                Text(studlist[index]['name']),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Student Roll Number: "),
                                                Text(studlist[index]['rollno'])
                                              ],
                                            ),
                                            Spacer(),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: butclr[index],
                                                shape: MaterialStateProperty
                                                    .all<CircleBorder>(
                                                  CircleBorder(),
                                                ),
                                              ),
                                              child: Icon(icon[index]),
                                              onPressed: () {
                                                setState(() {
                                                  if (icon[index] ==
                                                      Icons.close) {
                                                    setButtonColor(
                                                        Colors.green[800],
                                                        index);
                                                    icon[index] = Icons.done;
                                                  } else {
                                                    setButtonColor(
                                                        Color(0xFFB00020),
                                                        index);
                                                    icon[index] = Icons.close;
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                updateAttendDB();
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
