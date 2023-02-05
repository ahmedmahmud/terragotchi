import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terragotchi/sharedPrefs.dart';
import 'EnvironmentPage.dart';
import 'colors.dart';
import 'home.dart';

class StatisticsWidget extends StatelessWidget {
  UserData data;
  Color boxColor = const Color.fromARGB(255, 88, 91, 112);
  TextStyle questionStyle = TextStyle(
      fontFamily: 'Space Mono',
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryFontColor);

  StatisticsWidget({super.key, required this.data});

  int getEnvValue() {
    return data.planetScore.round();
  }

  int getHealthValue() {
    return data.healthScore.round();
  }

  int getSleepValue() {
    return data.sleepScore.round();
  }

  TextStyle style = TextStyle(
      fontFamily: 'Space Mono',
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryFontColor);

  Future<void> pressButton() async {
    await (await getData()).clear();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

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
            const SizedBox(
              height: 150,
            ),
            Text(
              'Environment score: ${getEnvValue()}',
              style: style,
              textAlign: TextAlign.center,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                disabledThumbColor: AppColors.primaryFontColor,
                disabledInactiveTrackColor: Colors.grey,
                disabledActiveTrackColor: AppColors.primaryFontColor,
              ),
              child: Slider(
                value: getEnvValue().toDouble(),
                max: 100,
                label: getEnvValue().round().toString(),
                onChanged: null,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Health score: ${getHealthValue()}',
              style: style,
              textAlign: TextAlign.center,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                disabledThumbColor: AppColors.primaryFontColor,
                disabledInactiveTrackColor: Colors.grey,
                disabledActiveTrackColor: AppColors.primaryFontColor,
              ),
              child: Slider(
                value: getHealthValue().toDouble(),
                max: 100,
                label: getHealthValue().round().toString(),
                onChanged: null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Sleep score: ${getSleepValue()}',
              style: style,
              textAlign: TextAlign.center,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                disabledThumbColor: AppColors.primaryFontColor,
                disabledInactiveTrackColor: Colors.grey,
                disabledActiveTrackColor: AppColors.primaryFontColor,
              ),
              child: Slider(
                value: getSleepValue().toDouble(),
                max: 100,
                label: getSleepValue().round().toString(),
                onChanged: null,
              ),
            ),
            const SizedBox(
              height: 220,
            ),
            Container(
              width: 300.0,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryFontColor,
                    textStyle: style),
                onPressed: () {
                  pressButton();
                },
                child: Text('Reset',
                    style: questionStyle, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
