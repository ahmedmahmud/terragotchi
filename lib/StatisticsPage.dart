import 'package:flutter/material.dart';
import 'EnvironmentPage.dart';
import 'colors.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.only(left: 20.0, top: 25.0),
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'statistics',
            style: TextStyle(fontFamily: 'Space Mono', fontSize: 28),
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
    );
  }
}
