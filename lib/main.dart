import 'package:first_app/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/welcome_page.dart';

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
