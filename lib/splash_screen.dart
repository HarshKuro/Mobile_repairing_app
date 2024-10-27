import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'homepage.dart'; // Make sure to import your homepage file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = true; // Make the splash screen content visible
      });
    });
    // Navigate to the home page after 3 seconds
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyHomePage())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 41, 6, 48)],
            ),
          ),
          child: Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0, // Fade in the content
              duration: const Duration(seconds: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/icon.png', // Replace with your actual logo path
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Alpha Testing',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 83, 7, 60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}