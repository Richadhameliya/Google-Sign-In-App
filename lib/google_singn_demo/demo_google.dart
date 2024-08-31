import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_app/google_singn_demo/profile_screen.dart';

class DemoGoogle extends StatefulWidget {
  const DemoGoogle({super.key});

  @override
  State<DemoGoogle> createState() => _DemoGoogleState();
}

class _DemoGoogleState extends State<DemoGoogle> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loading = false;
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Google Sign In'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      try {
                        GoogleSignInAccount? account =
                            await googleSignIn.signIn();
                        if (account == null) {
                          setState(() {
                            loading = false;
                          });
                          return;
                        }

                        GoogleSignInAuthentication authentication =
                            await account.authentication;
                        OAuthCredential oAuthCredential =
                            GoogleAuthProvider.credential(
                          accessToken: authentication.accessToken,
                          idToken: authentication.idToken,
                        );

                        UserCredential userCredential =
                            await auth.signInWithCredential(oAuthCredential);

                        await firestore
                            .collection('googleUser')
                            .doc(userCredential.user!.uid)
                            .set({
                          'email': userCredential.user!.email,
                          'name': userCredential.user!.displayName,
                          'photoURL': userCredential.user!.photoURL,
                          'uid': userCredential.user!.uid,
                        });

                        final goggleUser = userCredential.user!.uid;
                        box.write('goggleUserId', goggleUser);
                        print(' ::::::  $goggleUser');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GoggleProfileScreen(user: userCredential.user!),
                          ),
                        );

                        print("EMAIL: ${userCredential.user!.email}");
                        print("NAME: ${userCredential.user!.displayName}");
                        print("PHOTO URL: ${userCredential.user!.photoURL}");
                        print("UID: ${userCredential.user!.uid}");
                      } catch (e) {
                        print("Error signing in with Google: $e");
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
