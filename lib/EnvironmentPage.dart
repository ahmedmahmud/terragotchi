import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'colors.dart';
import 'home.dart';

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

  String transportValue = 'walk';
  String methodValue = 'self';
  String dietValue = 'red meat';

  var transport = [
    'walk',
    'cycle',
    'bus',
    'car',
  ];
  var method = [
    'self',
    'bought',
    'delivery',
    'car',
  ];
  var diet = [
    'red meat',
    'fish',
    'white meat',
    'vegetarian',
  ];

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(50, 225, 215, 227),
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        textStyle: const TextStyle(fontFamily: 'Space Mono', fontSize: 18));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.only(left: 20.0, top: 25.0),
          icon: const Icon(Icons.arrow_back_ios),
        ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DropdownButton(
                  value: transportValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: transport.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,
                          style: const TextStyle(
                            fontFamily: 'Space Mono',
                            fontSize: 28,
                          )),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      transportValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                DropdownButton(
                  value: methodValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: method.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(
                            fontFamily: 'Space Mono', fontSize: 28),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      methodValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                DropdownButton(
                  value: dietValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: diet.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(
                            fontFamily: 'Space Mono', fontSize: 28),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dietValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30),
              ]),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ElevatedButton(
                style: style,
                onPressed: active[1] ? () => pressButton(1, 5, true) : null,
                child: const Text('donated used items'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ElevatedButton(
                style: style,
                onPressed: active[2] ? () => pressButton(2, 5, true) : null,
                child: const Text('recycled rubbish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
