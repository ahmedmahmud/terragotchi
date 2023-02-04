import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'home.dart';
import 'AccountPage.dart';
import 'StatisticsPage.dart';

class EnvironmentWidget extends StatefulWidget {
  const EnvironmentWidget({super.key});

  @override
  State<EnvironmentWidget> createState() => EnvironmentPage();
}

class EnvironmentPage extends State<EnvironmentWidget> {
  static double totalScore = 0;
  int healthScore = 0;
  static double envScore = 0;
  static List<bool> active = [true, true, true];

  late RestartableTimer timer;

  void activateButton() {
    setState(() {
      for (int i = 0; i < EnvironmentPage.active.length; i++) {
        EnvironmentPage.active[i] = true;
      }
      timer.reset();
    });
  }

  @override
  void initState() {
    super.initState();

    /// Initialize timer for 3 seconds, it will be active as soon as intialized
    timer =
        RestartableTimer(const Duration(seconds: 3), () => activateButton());
  }

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
      totalScore = (healthScore + envScore) / 2;
    });
  }

  void pressButton(int i, int val, bool env) {
    setState(() {
      if (env) {
        envScore += val;
        _updateTotalScore();
      } else {
        healthScore += val;
        _updateTotalScore();
      }
      active[i] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(50, 225, 215, 227),
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        textStyle: const TextStyle(fontFamily: 'Space Mono', fontSize: 18));

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'submit task',
            style: TextStyle(fontFamily: 'Space Mono', fontSize: 28),
          ),
        ),
        backgroundColor: primaryColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: style,
              onPressed: active[0] ? () => pressButton(0, 5, true) : null,
              child: const Text('carbon-free travel'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: active[1] ? () => pressButton(1, 5, true) : null,
              child: const Text('donated used items'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: active[2] ? () => pressButton(2, 5, true) : null,
              child: const Text('recycled rubbish'),
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
