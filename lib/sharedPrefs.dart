import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'colors.dart';
import 'home.dart';

Future<SharedPreferences> getData() async {
  return await SharedPreferences.getInstance();
}

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  SetupState createState() => SetupState();
}

class SetupState extends State<Setup> {
  BrowserEvent? _event;
  StreamSubscription<BrowserEvent>? _browserEvents;

  @override
  void initState() {
    super.initState();
    _browserEvents = FlutterWebBrowser.events().listen((event) {
      setState(() {
        _event = event;
      });
    });
    doSetup(context);
  }

  @override
  void dispose() {
    _browserEvents?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_event != null && _event is CloseEvent) {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyApp())),
      );
    }
    return Container(
      color: AppColors.primaryColor,
    );
  }
}

void doSetup(BuildContext context) async {
  await (await getData()).clear();
  if ((await getData()).getString('ref_id') == null) {
    final res = await http.get(Uri.parse(
        'https://5958-2a0c-5bc0-40-2e34-fbce-a082-7d2-f71b.eu.ngrok.io/generate_url'));
    final urlData = URLData.fromJson(jsonDecode(res.body));
    (await getData()).setString('ref_id', urlData.ref_id);
    await FlutterWebBrowser.openWebPage(
      url: urlData.url,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Color.fromARGB(255, 203, 166, 247),
        preferredControlTintColor: Color.fromARGB(230, 255, 255, 255),
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  } else {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyApp())),
    );
  }
}

class URLData {
  final String ref_id;
  final String url;

  const URLData({required this.ref_id, required this.url});

  factory URLData.fromJson(Map<String, dynamic> json) {
    return URLData(ref_id: json['ref_id'], url: json['url']);
  }
}
