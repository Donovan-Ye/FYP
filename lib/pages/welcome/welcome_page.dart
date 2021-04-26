import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/login/log_in_page.dart';
import 'package:fyp_yzj/pages/signup/sign_up_page.dart';
import 'package:fyp_yzj/pages/signup/user_type_page.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/widget/text_divider.dart';

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
              margin: const EdgeInsets.only(top: 120.0),
              child: Center(
                child: Text(
                  "Welcome to",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30),
                ),
              ),
            ),
            Container(
              height: 80,
              child: Center(
                  child: Image(
                image: AssetImage("assets/images/icon/icon_white.png"),
              )),
            ),
            const SizedBox(height: 100),
            RaisedButton(
              onPressed: () {
                Get.toNamed(LogInPage.routeName);
              },
              child: Text('Log In', style: TextStyle(fontSize: 15)),
              color: Color(0xff008AF3),
              padding: EdgeInsets.fromLTRB(150, 15, 150, 15),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(height: 40),
            TextDivider(content: "OR"),
            const SizedBox(height: 20),
            Container(
              child: GestureDetector(
                child: Text(
                  "Sign up with email",
                  style: TextStyle(color: Color(0xff304F9D), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Get.toNamed(UserTypePage.routeName);
                },
              ),
            ),
          ],
        ));
  }
}
