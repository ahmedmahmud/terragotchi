import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:terragotchi/sharedPrefs.dart';
import 'LeaderboardPage.dart';
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
      debugShowCheckedModeBanner: false,
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

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;
  UserData? data;
  Timer? timer;

  // for scores
  int envIndex = 0;
  int healthIndex = 1;
  int sleepIndex = 2;

  // 0 to 35 to process the scores
  // 35 to 60
  // 60 to 100
  // 35 to 60
  // 60 to 100
  // then render the stack
  // takes in a list of scores, each representing a category [0, 1 or 2]
  // [<score-env>, <score-health>, <score-sleep>]

  // calculates the picture numbers from score
  int calulateScoreInt(int? score) {
    int safe = score ?? 0;
    if (safe < 35) {
      return 0;
    } else if (safe < 60) {
      return 1;
    } else {
      return 2;
    }
  }

  UserData resolveUserData(UserData? data) {
    return data ??
        const UserData(healthScore: 0, planetScore: 0, sleepScore: 0);
  }

  // gets overlayed image of current state
  Stack getImage(List<int?> scores) {
    return Stack(children: [
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[envIndex])}-Base.png'),
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[envIndex])}-Green.png'),
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[healthIndex])}-Calorie.png'),
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[envIndex])}-Air.png'),
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[sleepIndex])}-Tired.png'),
      Image.asset(
          'assets/images/earth/${calulateScoreInt(scores[healthIndex])}-Feel.png'),
      Image.asset('assets/images/earth/Frontshine.png'),
    ]);
  }

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
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: RadialGradient(
            // Where the linear gradient begins and ends
            // Add one stop for each color. Stops should increase from 0 to 1
            radius: 0.8,
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              AppColors.secondaryColor,
              Colors.black,
              AppColors.primaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            loaded
                ? getImage(
                    [data?.planetScore, data?.healthScore, data?.sleepScore])

                // Text(
                //     'Current total score: ${data?.sleepScore.round()}',
                //     style:
                //         const TextStyle(fontFamily: 'Space Mono', fontSize: 18),
                //   )
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
        selectedItemColor: AppColors.tertiaryColor,
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
              MaterialPageRoute(
                  builder: (context) => StatisticsWidget(
                        data: resolveUserData(data),
                      )),
            ).then((value) => setState(() {}));
          }
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LeaderboardWidget()),
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
            label: 'leaderboard',
          ),
        ],
      ),
    );
  }
}

class UserData {
  // each from 0 to 100
  final int sleepScore;
  final int healthScore;
  final int planetScore; // is envScore

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
