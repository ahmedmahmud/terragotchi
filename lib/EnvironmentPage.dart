import 'dart:convert';
import 'package:terragotchi/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
// import 'home.dart';

// Widget that tracks activities that help enviroment
class EnvironmentWidget extends StatefulWidget {
  const EnvironmentWidget({super.key});

  @override
  State<EnvironmentWidget> createState() => EnvironmentPage();
}

class EnvironmentPage extends State<EnvironmentWidget> {
  // Static variables Score
  static double totalScore = 0;
  int healthScore = 0;
  static double envScore = 0;

  // List which tables should be active
  static List<bool> active = [true, true, true];

  late RestartableTimer timer;

  // Resets all the tables to be active (aka all true)
  void activateButton() {
    setState(() {
      for (int i = 0; i < EnvironmentPage.active.length; i++) {
        EnvironmentPage.active[i] = true;
      }
      timer.reset();
    });
  }

  // Initialize the State
  @override
  void initState() {
    super.initState();

    /// Initialize timer for 3 seconds, it will be active as soon as intialized
    timer =
        RestartableTimer(const Duration(seconds: 3), () => activateButton());
  }

  // Increment Score Functions
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

  // Updates the Total Score as avg of health and env score
  void _updateTotalScore() {
    setState(() {
      totalScore = (healthScore + envScore) / 2;
    });
  }

  // By press of the button update the score
  // i   = which (the order) the activity is
  // val = cooldown
  void pressButton(int i, int val) async {
    String refid = (await getData()).getString('ref_id') ?? "";
    if (i == 0) {
      http.post(
        Uri.parse(
            'https://5958-2a0c-5bc0-40-2e34-fbce-a082-7d2-f71b.eu.ngrok.io/send_action/$refid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'type': 'journey',
          'mode': transportValue,
        }),
      );
    }

    if (i == 1) {
      http.post(
        Uri.parse(
            'https://5958-2a0c-5bc0-40-2e34-fbce-a082-7d2-f71b.eu.ngrok.io/send_action/$refid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'type': 'meal',
          'method': methodValue,
          'category': dietValue,
        }),
      );
    }

    if (i == 2) {
      http.post(
        Uri.parse(
            'https://5958-2a0c-5bc0-40-2e34-fbce-a082-7d2-f71b.eu.ngrok.io/send_action/$refid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'type': 'recycle',
        }),
      );
    }

    setState(() {
      active[i] = false;
    });
  }

  // Placeholders for the drop box
  String transportValue = 'walk';
  String methodValue = 'self';
  String dietValue = 'red meat';

  // i = 2 (for env) Form of Transportation
  var transport = [
    'walk',
    'cycle',
    'bus',
    'car',
  ];

  // i = 1 (for env) Method of Getting Food
  var method = [
    'self',
    'bought',
    'delivery',
  ];

  // i = 2 (for env) Diet Type
  var diet = [
    'red meat',
    'fish',
    'white meat',
    'vegetarian',
  ];

  // Actually building the program
  @override
  Widget build(BuildContext context) {
    // style for the buttons (not drop downs)
    // final ButtonStyle style = ElevatedButton.styleFrom(
    //     backgroundColor: const Color.fromARGB(50, 225, 215, 227),
    //     shadowColor: const Color.fromARGB(0, 0, 0, 0),
    //     textStyle: const TextStyle(fontFamily: 'Space Mono', fontSize: 18));

    // style for drop box buttons
    TextStyle style = TextStyle(
        fontFamily: 'Space Mono',
        fontSize: 16,
        color: AppColors.tertiaryFontColor);

    TextStyle questionStyle = TextStyle(
        fontFamily: 'Space Mono',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryFontColor);

    double smallSpace = 5.0;
    double bigSpace = 6.0;

    Color boxColor = const Color.fromARGB(255, 88, 91, 112);
    double dropboxSize = 200.0;

    Color disabledColor = Colors.black54;

    return Scaffold(
        // navigate back and the top part of the app
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            icon: const Icon(Icons.arrow_back_ios),
          ),

          // The title of the Page
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'submit task',
              style: TextStyle(fontFamily: 'Space Mono', fontSize: 28),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Travel
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              color: active[0] ? boxColor : disabledColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Travel In Drop Box
              SizedBox(height: bigSpace),
              Text(
                'How did you travel in today?',
                style: questionStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: smallSpace),
              Container(
                width: dropboxSize,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: active[0] ? boxColor : disabledColor,
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: transportValue,
                  dropdownColor: active[0] ? boxColor : disabledColor,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: transport.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: style,
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      transportValue = newValue!;
                    });
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryFontColor,
                    textStyle: style),
                onPressed: active[0] ? () => pressButton(0, 5) : null,
                child: Text('Submit',
                    style: questionStyle, textAlign: TextAlign.center),
              ),
            ]),
          ),
          SizedBox(height: bigSpace),

          // Method of food
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              color: active[1] ? boxColor : disabledColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Method of Food
              SizedBox(height: bigSpace),
              Text(
                'How did you eat today?',
                style: questionStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: smallSpace),
              Container(
                width: dropboxSize,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: active[1] ? boxColor : disabledColor,
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: methodValue,
                  dropdownColor: active[1] ? boxColor : disabledColor,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: method.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: style,
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      methodValue = newValue!;
                    });
                  },
                ),
              ),

              // Diet
              SizedBox(height: bigSpace),
              Text(
                'What was the diet type?',
                style: questionStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: smallSpace),
              Container(
                width: dropboxSize,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: active[1] ? boxColor : disabledColor,
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: dietValue,
                  dropdownColor: active[1] ? boxColor : disabledColor,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: diet.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: style,
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dietValue = newValue!;
                    });
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryFontColor,
                    textStyle: style),
                onPressed: active[1] ? () => pressButton(1, 5) : null,
                child: Text('Submit',
                    style: questionStyle, textAlign: TextAlign.center),
              ),
            ]),
          ),
          SizedBox(height: bigSpace),

          // Recycling Trash
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              color: active[2] ? boxColor : disabledColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryFontColor,
                  textStyle: style),
              onPressed: active[2] ? () => pressButton(2, 5) : null,
              child: Text('I Recycled Rubbish',
                  style: questionStyle, textAlign: TextAlign.center),
            ),
          ),
        ])));
  }
}
