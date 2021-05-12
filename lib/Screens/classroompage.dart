import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_mate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ClassRoom extends StatefulWidget {
  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  List<dynamic> lists = [];

  Future<DataSnapshot> getSubSnapshot() async {
    String curclass;
    lists.clear();

    if (cd.curclass != null) {
      curclass = cd.curclass;
    } else {
      String curmail = await FirebaseAuth.instance.currentUser.email;
      curmail = curmail.replaceAll('.', ',');
      final dbref1 =
          FirebaseDatabase.instance.reference().child("user/$curmail/ccode");
      await dbref1.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, val) {
          if (val == '-') {
            curclass = key;
            cd.curclass = key;
          }
        });
      });
    }
    //print(curclass);
    final dbref = FirebaseDatabase.instance
        .reference()
        .child('class/$curclass/subject')
        .once();
    // await dbref.once().then((DataSnapshot snapshot) {
    //   //print(snapshot.value);
    //   return snapshot;
    // });
    return dbref;
  }

  @override
  // initState() {
  //   super.initState();
  //   // Add listeners to this class
  //   getSnapshot().then((value) {
  //     DatabaseReference dref = value;
  //     print(dref.once());
  //   });
  // }

  FirebaseAuth auth = FirebaseAuth.instance;
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
        automaticallyImplyLeading: false,
        title: Text("Class Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/viewcalendarpage');
                    },
                    child: Text(
                      'View Calendar',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/viewattendancepage');
                    },
                    child: Text('View Attendance'),
                  ),
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(child: Text('Subjects List :')),
            ),
            FutureBuilder(
                future: getSubSnapshot(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    //print(snapshot.data.value);
                    lists.clear();
                    String x = snapshot.data.value.toString();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    if (values != null) {
                      values.forEach((key, values) {
                        lists.add(values);
                      });
                    }
                    return Expanded(
                      flex: 1,
                      child: (values == null || values.isEmpty)
                          ? Card(
                              color: Colors.grey.shade900,
                              child: Center(
                                child: Text('Empty'),
                              ),
                            )
                          : Card(
                              color: Colors.grey.shade900,
                              child: Scrollbar(
                                isAlwaysShown: true,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: new ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: lists.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Subject Code: " +
                                                        lists[index]
                                                            ["subcode"]),
                                                    Text("Subject Name: " +
                                                        lists[index]
                                                            ["subname"]),
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/facultyjoinpage');
                        },
                        child: Text('Join as Faculty',
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(
                          'Add/Remove Subject',
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          String curmail =
                              await FirebaseAuth.instance.currentUser.email;
                          curmail = curmail.replaceAll('.', ',');
                          final _dbref = FirebaseDatabase.instance
                              .reference()
                              .child("user/$curmail/designation");
                          await _dbref.once().then((DataSnapshot snapshot) {
                            Map<dynamic, dynamic> values = snapshot.value;
                            if (values['code'] != 'null' &&
                                values['post'] == 'cr') {
                              Navigator.of(context)
                                  .pushNamed('/createsubjectpage');
                            } else {
                              print('Only CR can add subjects');
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
