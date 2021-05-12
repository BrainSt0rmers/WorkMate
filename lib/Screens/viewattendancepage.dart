import 'package:flutter/material.dart';
import 'package:work_mate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

class ViewAttendance extends StatefulWidget {
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> clslist = [];
  List<dynamic> sublist = [];
  List<dynamic> attlist = [];
  List<dynamic> subname = [];
  List<dynamic> subcode = [];
  List<dynamic> percent = [];

  Future<List> getSubAttendance() async {
    clslist.clear();
    sublist.clear();
    attlist.clear();
    subname.clear();
    subcode.clear();
    percent.clear();
    final dbref1 =
        FirebaseDatabase.instance.reference().child('user/${cd.curmail}/ccode');
    await dbref1.once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, val) {
        if (val == '-') {
          clslist.add(key);
        } else {
          sublist.add(key);
          attlist.add(val);
        }
      });
    });
    for (int i = 0; i < attlist.length; i++) {
      if (attlist[i]['numofclasses'] == 0) {
        var h = 100.toStringAsFixed(2);
        percent.add(h);
      } else {
        double a =
            (attlist[i]['numofattended'] / attlist[i]['numofclasses']) * 100;
        var b = a.toStringAsFixed(2);
        //print(b);
        percent.add(b);
      }
    }
    //print(percent);
    for (int i = 0; i < clslist.length; i++) {
      //print(clslist);
      for (int j = 0; j < sublist.length; j++) {
        final dbref2 = FirebaseDatabase.instance
            .reference()
            .child('class/${clslist[i]}/subject/${sublist[j]}');
        await dbref2.once().then((DataSnapshot snap) {
          Map<dynamic, dynamic> values = snap.value;
          subcode.add(values['subcode']);
          subname.add(values['subname']);
        });
      }
    }

    return sublist;
  }

  Color setClr(String x) {
    if (double.parse(x) > 85 && double.parse(x) <= 100) {
      return Colors.green;
    } else if (double.parse(x) > 75 && double.parse(x) <= 85) {
      return Colors.orange[700];
    } else {
      return Colors.red;
    }
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
        title: Text("View Attendance"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 67, right: 18, top: 8, bottom: 8),
              child: Row(
                children: [
                  Text('Subject'),
                  Spacer(),
                  Text('Attendance'),
                ],
              ),
            ),
            FutureBuilder(
              future: getSubAttendance(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.none) {
                  return Container();
                } else if (snap.connectionState == ConnectionState.done) {
                  return Expanded(
                    // child: (snap.data == null || snap.data.isEmpty)
                    //     ? Card(
                    //         color: Colors.grey.shade900,
                    //         child: Center(
                    //           child: Text('Empty'),
                    //         ),
                    //       )
                    //     :
                    child: Card(
                      color: Colors.grey.shade900,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new ListView.builder(
                              shrinkWrap: true,
                              itemCount: sublist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("Subject Code: " +
                                                        subcode[index]),
                                                    Text("Subject Name: " +
                                                        subname[index]),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    CircularPercentIndicator(
                                                      animation: true,
                                                      animationDuration: 1000,
                                                      radius: 65.0,
                                                      lineWidth: 5.0,
                                                      percent: 1.0,
                                                      center: Text(
                                                          '${percent[index]}' +
                                                              '%'),
                                                      progressColor: setClr(
                                                          percent[index]),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
