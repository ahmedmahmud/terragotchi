import 'dart:ui';

import 'package:flutter/material.dart';
import 'AccountPage.dart';
import 'EnvironmentPage.dart';
import 'StatisticsPage.dart';

Color? primaryColor = Colors.deepPurpleAccent[100];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerraGotchi App',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
      ),
      home: const MyHomePage(title: 'terragotchi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  // returns a list of scores, each representing a category
  Stack getImage(List<int> scores) {
    return Stack(children: [
      Image.asset('assets/images/earth${scores[0]}.png'),
      Image.asset('assets/images/mood${scores[1]}.png'),
    ]);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'Space Mono', fontSize: 28),
          ),
        ),
        backgroundColor: primaryColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current total score: ${EnvironmentPage.totalScore.round()}',
              style: TextStyle(fontFamily: 'Space Mono', fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // style
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Space Mono', fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Space Mono', fontSize: 14),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0.0,
        backgroundColor: primaryColor,
        // function
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EnvironmentWidget()),
            ).then((value) => setState(() {}));
          }
          if (value == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsWidget()),
            ).then((value) => setState(() {}));
          }
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountWidget()),
            ).then((value) => setState(() {}));
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded),
            label: 'environment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'account',
          ),
        ],
      ),
    );
  }
}
