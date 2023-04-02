import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes/screens/addNote_Page.dart';
import 'package:firebase_notes/screens/editNote%20_Page.dart';
import 'package:firebase_notes/screens/home_page.dart';
import 'package:firebase_notes/screens/logIn_page.dart';
import 'package:firebase_notes/screens/signUp_page.dart';
import 'package:firebase_notes/screens/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: 'splashScreen',
      routes: {
        '/': (context) => const MyApp(),
        'addNotePage': (context) => const addNotePage(),
        'welcomePage': (context) => const WelcomePage(),
        'logInPage': (context) => const SignInPage(),
        'signUpPage': (context) => const SignUpPage(),
        'editNotePage': (context) => const EditNotePage(),
        'splashScreen': (context) => const spalshScreen(),
      },
    ),
  );
}

class spalshScreen extends StatefulWidget {
  const spalshScreen({Key? key}) : super(key: key);

  @override
  State<spalshScreen> createState() => _spalshScreenState();
}

class _spalshScreenState extends State<spalshScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, 'welcomePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            builder: (context, val, widget) {
              return Transform.scale(
                scale: val,
                child: widget,
              );
            },
            child: Image.asset(
              "assets/images/Notes_logo.png",
              height: 200,
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
