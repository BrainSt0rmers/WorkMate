import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:work_mate/Screens/createclassroompage.dart';
import 'package:work_mate/Screens/createsubjectpage.dart';
import 'package:work_mate/Screens/facultyjoinpage.dart';
import 'package:work_mate/Screens/homepage.dart';
import 'package:work_mate/Screens/joinclasspage.dart';
import 'package:work_mate/Screens/loginpage.dart';
import 'package:work_mate/Screens/signuppage.dart';
import 'package:work_mate/Screens/classroompage.dart';
import 'package:work_mate/Screens/createsubjectpage.dart';
import 'package:work_mate/Screens/facultyjoinpage.dart';
import 'package:work_mate/Screens/manageattendancepage.dart';
import 'package:work_mate/Screens/viewattendancepage.dart';
import 'package:work_mate/Screens/managecalendarpage.dart';
import 'package:work_mate/Screens/viewcalendarpage.dart';

CurUserDetails cd = new CurUserDetails();

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFFB00020),
        accentColor: Color(0xFFB00020),
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFB00020),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Color(0xFFB00020),
          ),
        ),
        primaryTextTheme: Typography.whiteCupertino,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => new LandingPage(),
        '/loginpage': (BuildContext context) => new LoginPage(),
        '/signuppage': (BuildContext context) => new SignUp(),
        '/homepage': (BuildContext context) => new HomePage(),
        '/createclassroompage': (BuildContext context) => new CreateClassRoom(),
        '/classroompage': (BuildContext context) => new ClassRoom(),
        '/joinclasspage': (BuildContext context) => new JoinClass(),
        '/createsubjectpage': (BuildContext context) => new CreateSubject(),
        '/facultyjoinpage': (BuildContext context) => new FacultyJoin(),
        '/manageattendancepage': (BuildContext context) =>
            new ManageAttendance(),
        '/viewattendancepage': (BuildContext context) => new ViewAttendance(),
        '/managecalendarpage': (BuildContext context) => new ManageCalendar(),
        '/viewcalendarpage': (BuildContext context) => new ViewCalendar(),
      },
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return LoginPage();
                } else {
                  cd.curmail = user.email.replaceAll('.', ',');
                  return HomePage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication..."),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text("Connecting to the app..."),
          ),
        );
      },
    );
  }
}

class CurUserDetails {
  String curmail;
  String curclass;
  String cursub;
}
