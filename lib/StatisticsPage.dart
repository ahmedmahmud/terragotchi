import 'package:flutter/material.dart';
import 'EnvironmentPage.dart';
import 'AccountPage.dart';
import 'home.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => StatisticsPage();
}

class StatisticsPage extends State<StatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'statistics',
            style: TextStyle(fontFamily: 'Space Mono', fontSize: 28),
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
              'Environment score: ${EnvironmentPage.envScore.round()}',
              style: const TextStyle(fontFamily: 'Space Mono', fontSize: 18),
            ),
            Slider(
              value: EnvironmentPage.envScore,
              max: 100,
              label: EnvironmentPage.envScore.round().toString(),
              onChanged: null,
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
