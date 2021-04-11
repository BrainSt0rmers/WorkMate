import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //final databaseReference = FirebaseDatabase.instance.reference();
  // void CreateData() {
  //   databaseReference
  //       .child("flutterDevsTeam1")
  //       .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
  // }

  String _email;
  String _password;

  Future<void> _createUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    } catch (e) {
      print("Error: $e");
    }
    //return LoginPage();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign-Up Page"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Roll Number...",
              ),
            ),
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: InputDecoration(
                hintText: "Enter E-mail Id...",
              ),
            ),
            TextField(
              onChanged: (value) {
                _password = value;
              },
              decoration: InputDecoration(
                hintText: "Enter Password...",
              ),
            ),
            Row(
              children: [
                ElevatedButton(onPressed: _createUser, child: Text("Create"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
