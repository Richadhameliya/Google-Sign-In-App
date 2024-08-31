import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoggleProfileScreen extends StatelessWidget {
  final User user;

  GoggleProfileScreen({super.key, required this.user});

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user.photoURL != null
                ? Image.network(
                    user.photoURL!,
                  )
                : Icon(Icons.account_circle, size: 100),
            SizedBox(height: 30),
            Text('Name: ${user.displayName ?? "No name"}'),
            SizedBox(height: 10),
            Text('Email: ${user.email ?? "No email"}'),
            SizedBox(height: 10),
            Text('UID: ${user.uid}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () async {
                try {
                  await googleSignIn.signOut();
                  await auth.signOut();
                  print("Successfully signed out");
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
