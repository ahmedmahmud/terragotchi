import 'package:flutter/material.dart';

class MySecondPage extends StatefulWidget {
  const MySecondPage({super.key});

  @override
  State<MySecondPage> createState() => SecondRoutes();
}

class SecondRoutes extends State<MySecondPage> {
  static int totalScore = 0;
  int healthScore = 0;
  int envScore = 0;

  void incrementHealth(int val) {
    setState(() {
      healthScore += val;
      _updateTotalScore();
    });
  }

  void incrementEnv(int val) {
    setState(() {
      envScore += val;
      _updateTotalScore();
    });
  }

  void _updateTotalScore() {
    setState(() {
      totalScore = (healthScore + envScore) ~/ 2;
    });
  }

  int getTotalScore() {
    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Second Route'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                    onPressed: () => incrementHealth(5),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: const Text("Health")),
                TextButton.icon(
                    onPressed: () => incrementEnv(5),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: const Text("Environment")),
              ],
            )));
  }
}
