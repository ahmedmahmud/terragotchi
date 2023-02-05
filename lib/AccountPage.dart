import 'package:flutter/material.dart';
import 'package:terragotchi/sharedPrefs.dart';
import 'colors.dart';
import 'home.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => AccountPage();
}

class AccountPage extends State<AccountWidget> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  Future<void> initialiseControllers() async {
    _controller1.text = (await getData()).getString("name") ?? "";
    _controller2.text = (await getData()).getString("age") ?? "";
    _controller3.text = (await getData()).getString("pronoun") ?? "";
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
            'account',
            style: TextStyle(
              fontFamily: 'Space Mono',
              fontSize: 28,
            ),
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
                onChanged: (val) async =>
                    {(await getData()).setString('name', val)},
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
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
                onChanged: (val) async =>
                    {(await getData()).setString('age', val)},
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
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
                onChanged: (val) async =>
                    {(await getData()).setString('pronoun', val)},
                style: const TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Set<void> initState() {
    super.initState();
    return {initialiseControllers()};
  }
}
