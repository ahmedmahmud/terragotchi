import 'package:flutter/material.dart';
import 'EnvironmentPage.dart';
import 'StatisticsPage.dart';
import 'home.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => AccountPage();
}

class AccountPage extends State<AccountWidget> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'accounts',
            style: TextStyle(
              fontFamily: 'Space Mono',
              fontSize: 28,
            ),
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
            const Text(
              'Name:',
              style: TextStyle(
                fontFamily: 'Space Mono',
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 200.0,
              height: 30,
              child: TextField(
                controller: _controller1,
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
                  hintText: 'Ahmed Mahmud',
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Age:',
              style: TextStyle(
                fontFamily: 'Space Mono',
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 200.0,
              height: 30,
              child: TextField(
                controller: _controller2,
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
                  hintText: '19',
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Pronouns:',
              style: TextStyle(
                fontFamily: 'Space Mono',
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 200.0,
              height: 30,
              child: TextField(
                controller: _controller3,
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
                  hintText: 'He/him',
                ),
              ),
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
