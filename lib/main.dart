import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/welcome/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter FYP',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: WelcomePage());
  }
}
