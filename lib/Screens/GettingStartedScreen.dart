import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelgenie/Screens/HomeScreen.dart';
import 'package:pixelgenie/constants.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return GettingStartedScreenWidget();
      },
    );
  }
}

class GettingStartedScreenWidget extends StatefulWidget {
  
  @override
  State<GettingStartedScreenWidget> createState() => _GettingStartedScreenWidgetState();
}

class _GettingStartedScreenWidgetState extends State<GettingStartedScreenWidget> {
  bool loading = false;

  String buttonText = "I WANT AI STICKERS!!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: kGradientBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pixel Genie",
              style: GoogleFonts.pixelifySans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            Image.asset("assets/images/genieSTARTED.png"),
            StarsButton(
              buttonText: buttonText,
              onPressed: () {
                setState(() {
                  buttonText = "Loading...";
                });
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    buttonText = "I WANT AI STICKERS!!";
                  });
                  Navigator.pushNamed(context, '/login');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StarsButton extends StatelessWidget {
  const StarsButton({
    required this.buttonText,
    required this.onPressed,
  });

  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kStarsBackgroundDecoration,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            buttonText,
            style: GoogleFonts.pixelifySans(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
