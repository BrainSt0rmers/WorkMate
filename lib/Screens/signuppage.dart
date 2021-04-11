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
  String email;
  String password;
  String username;
  String a = "amvo1taaum@gmailcom";

  final databaseReference = FirebaseDatabase.instance.reference();
  void CreateData() {
    //databaseReference.set({_email});
    String em = email.replaceAll('.', ',');
    databaseReference.child("user/$em").set({'username': username});
    //databaseReference.child("username").set({'random: 1234'});
    //print(databaseReference.key);
  }

  Future<void> _createUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    } catch (e) {
      print("Error: $e");
    }
    //return LoginPage();
    CreateData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign-Up Page"),
        //backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                username = value;
              },
              decoration: InputDecoration(
                hintText: "Enter Roll Number...",
              ),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: "Enter E-mail Id...",
              ),
            ),
            TextField(
              onChanged: (value) {
                password = value;
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
