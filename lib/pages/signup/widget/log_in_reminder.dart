import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/login/log_in_page.dart';
import 'package:get/get.dart';

class LogInReminder extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Already has account? ",
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Container(
          child: GestureDetector(
            child: Text(
              "Log In",
              style: TextStyle(color: Color(0xff008AF3), fontSize: 15),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Get.toNamed(LogInPage.routeName);
            },
          ),
        ),
      ],
    );
  }
}
