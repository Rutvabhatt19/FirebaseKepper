import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_kepper/Mixinfun.dart';
import 'package:firebase_kepper/View/SignInScreen.dart';
import 'package:firebase_kepper/View/Homepage.dart';
import 'package:firebase_kepper/View/IntroScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with GlobalFun {
  @override
  void initState() {
    super.initState();
    _checkIfIntroScreenSeen();
  }

  Future<void> _checkIfIntroScreenSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seenIntro = prefs.getBool('seenIntro') ?? false;

    await Future.delayed(Duration(seconds: 3));

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else if (seenIntro) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text1('Firebase_Kepper', 20, FontWeight.bold)),
    );
  }
}
