import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const Splash());
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Splash Screen',
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Container(
        width: 60.0,
        child: Column(children: <Widget>[
          const SizedBox(height: 120),
          Image.asset(
            'assets/images/alien.png',
            fit: BoxFit.cover,
            // width: 200,
          ),
          const SizedBox(height: 120),
          Image.asset(
            'assets/images/terra.png',
            fit: BoxFit.cover,
            width: 200,
          ),
        ]),
      ),
    );
  }
}
