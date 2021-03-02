import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:first_app/pages/log_in_page.dart';
import 'package:first_app/pages/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  _log() {
    print("点击了按钮");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 250.0),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LogInPage();
                }));
              },
              child: Text('Log In', style: TextStyle(fontSize: 25)),
              color: Color(0xff03DAC5),
              padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignUpPage();
                }));
              },
              child: Text('Sign Up', style: TextStyle(fontSize: 25)),
              color: Color(0xff676a6a),
              padding: EdgeInsets.fromLTRB(82, 14, 82, 14),
              textColor: Colors.white,
            )
          ],
        ));
  }
}
