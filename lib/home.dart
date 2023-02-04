import 'package:flutter/material.dart';

import 'secondPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terragotchi App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(title: 'Terragotchi 👾'),
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
  int _totalScore = 0;
  int _healthScore = 0;
  int _envScore = 0;

  void _incrementHealth(int val) {
    setState(() {
      _healthScore += val;
      _updateTotalScore();
    });
  }

  void _incrementEnv(int val) {
    setState(() {
      _envScore += val;
      _updateTotalScore();
    });
  }

  void _updateTotalScore() {
    setState(() {
      _totalScore = (_healthScore + _envScore) ~/ 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Current total score:',
              ),
              Text(
                '$_totalScore',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                    onPressed: () => _incrementHealth(5),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: const Text("Health")),
                TextButton.icon(
                    onPressed: () => _incrementEnv(5),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: const Text("Environment")),
                ElevatedButton(
                  child: const Text('To next page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondRoute()),
                    );
                  },
                ),
              ],
            )));
  }
}
