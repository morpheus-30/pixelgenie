import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pixelgenie/Screens/GettingStartedScreen.dart';
import 'package:pixelgenie/Screens/HomeScreen.dart';
import 'package:pixelgenie/firebaseFunctions.dart';
import 'package:pixelgenie/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              decoration: kGradientBackgroundDecoration,
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 200,
                  width: 200,
                )
              ),
            );
        } else if (snapshot.hasError) {
          return const Center(
            child: Scaffold(
              body: Text("Error occurred"),
            ),
          );
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreenWidget();
        }
      },
    );
  }
}

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({
    super.key,
  });

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
          decoration: kGradientBackgroundDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/genieLogin.png"),
              StarsButton(
                  buttonText: "Login FASTTT!",
                  onPressed: () async {
                    await signInWithGoogle();
                    // print(FirebaseAuth.instance.currentUser!.displayName);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
