import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'createclassroompage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text("Sign Out"),
          ),
        ],
        backgroundColor: Colors.blue,
        title: Text("Homepage"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateClassRoom(),
                    ),
                  );
                },
                child: Text("Create Class"),
              ),
              TextField(
                decoration:
                InputDecoration(hintText: "Join Class as Student..."),
              ),
              TextField(
                decoration:
                InputDecoration(hintText: "Join Class as Faculty..."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}