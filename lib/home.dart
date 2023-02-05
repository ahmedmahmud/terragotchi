import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:terragotchi/sharedPrefs.dart';
import 'AccountPage.dart';
import 'EnvironmentPage.dart';
import 'StatisticsPage.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'terragotchi',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.primaryColor,
      ),
      home: const MyHomePage(title: 'terragotchi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  // takes in a list of scores, each representing a category [0, 1 or 2]
  Stack getImage(List<int> scores) {
    return Stack(children: [
      Image.asset('assets/images/earth/${scores[0]}-Base.png'),
      Image.asset(
          'assets/images/earth/${EnvironmentPage.envScore / ~33}-Green.png'),
      Image.asset('assets/images/earth/${scores[0]}-Calorie.png'),
      Image.asset('assets/images/earth/${scores[0]}-Air.png'),
      Image.asset('assets/images/earth/${scores[0]}-Tired.png'),
      Image.asset('assets/images/earth/${scores[0]}-Feel.png'),
      Image.asset('assets/images/earth/Frontshine.png'),
    ]);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;
  UserData? data;
  Timer? timer;

  void updateScoreState() async {
    print("in upd");
    String? refId = (await getData()).getString('ref_id');
    final res = await http.get(Uri.parse(
        'https://5958-2a0c-5bc0-40-2e34-fbce-a082-7d2-f71b.eu.ngrok.io/get_values/${refId!}'));
    setState(() {
      data = UserData.fromJson(jsonDecode(res.body));
      loaded = true;
    });
  }

  @override
  void initState() {
    print("in init");
    super.initState();
    updateScoreState();
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => updateScoreState());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
        backgroundColor: AppColors.primaryColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current total score: ${EnvironmentPage.totalScore.round()}',
              style: const TextStyle(fontFamily: 'Space Mono', fontSize: 18),
            ),
            loaded
                ? Text(
                    'Current total score: ${data?.sleepScore.round()}',
                    style:
                        const TextStyle(fontFamily: 'Space Mono', fontSize: 18),
                  )
                : const Text(''),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // style
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Space Mono', fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Space Mono', fontSize: 14),
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.secondaryColor,
        elevation: 0.0,
        backgroundColor: AppColors.primaryColor,
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

class UserData {
  final int sleepScore;
  final int healthScore;
  final int planetScore;

  const UserData(
      {required this.sleepScore,
      required this.healthScore,
      required this.planetScore});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        sleepScore: json['sleep'],
        healthScore: json['health'],
        planetScore: json['planet']);
  }
}
