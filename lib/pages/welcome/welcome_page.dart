import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/login/log_in_page.dart';
import 'package:fyp_yzj/pages/signup/sign_up_page.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/welcome';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => WelcomePage());
  }

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 230.0),
              child: Center(
                child: Text(
                  "Welcome to",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  "Patronus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50),
                ),
              ),
            ),
            const SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                Get.toNamed(LogInPage.routeName);
              },
              child: Text('Log In', style: TextStyle(fontSize: 25)),
              color: Color(0xff03DAC5),
              padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                Get.toNamed(SignUpPage.routeName);
              },
              child: Text('Sign Up', style: TextStyle(fontSize: 25)),
              color: Color(0xff676a6a),
              padding: EdgeInsets.fromLTRB(82, 12, 82, 12),
              textColor: Colors.white,
            )
          ],
        ));
  }
}
