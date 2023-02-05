import 'package:flutter/material.dart';
import 'EnvironmentPage.dart';
import 'colors.dart';
import 'home.dart';

class StatisticsWidget extends StatelessWidget {
  UserData data;

  StatisticsWidget({super.key, required this.data});

  int getEnvValue() {return data.planetScore.round();}
  int getHealthValue() {return data.healthScore.round();}
  int getSleepValue() {return data.sleepScore.round();}

  TextStyle style = TextStyle(fontFamily: 'Space Mono', 
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: AppColors.secondaryFontColor);

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
              'Environment score: ${data.planetScore.round()}',
              style: style,
              textAlign: TextAlign.center,
            ),
            Slider(
              value: data.planetScore.toDouble(),
              max: 100,
              label: data.planetScore.round().toString(),
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }
}