import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:work_mate/main.dart';

class FacultyHome extends StatefulWidget {
  @override
  _FacultyHomeState createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  List<dynamic> ccodelist = [];
  List<dynamic> classlist = [];
  List<dynamic> csublist = [];

  Future<DataSnapshot> getClassSnapshot() async {
    String curmail = cd.curmail;
    curmail = curmail.replaceAll('.', ',');
    final dbref1 = await FirebaseDatabase.instance
        .reference()
        .child('user/$curmail/ccode')
        .once();

    ccodelist.clear();
    classlist.clear();
    csublist.clear();
    await addToClassList(dbref1);

    return dbref1;
  }

  Future<void> addToClassList(DataSnapshot snapshot) async {
    Map<dynamic, dynamic> values = snapshot.value;
    for (var val in values.entries) {
      ccodelist.add(val.key);
      csublist.add(val.value);
      await FirebaseDatabase.instance
          .reference()
          .child('class/${val.key}')
          .once()
          .then((DataSnapshot snap) async {
        Map<dynamic, dynamic> v = snap.value;
        classlist.add(v['classname']);
      });
    }
  }

  @override
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
          title: Text("Faculty Home Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Class List:'),
              ),
              FutureBuilder(
                  future: getClassSnapshot(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
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
                                  itemCount: classlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Class Name: " +
                                                    classlist[index]),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        cd.curclass =
                                                            ccodelist[index];
                                                        cd.cursub =
                                                            csublist[index];
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/managecalendarpage');
                                                      },
                                                      child: Text(
                                                        'Manage Calendar',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        cd.curclass =
                                                            ccodelist[index];
                                                        cd.cursub =
                                                            csublist[index];
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/manageattendancepage');
                                                      },
                                                      child: Text(
                                                        'Manage Attendance',
                                                      ),
                                                    ),
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
                  }),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/joinclasspage');
                },
                child: Text('Add Class'),
              ),
            ],
          ),
        ));
  }
}
