import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/welcome/welcome_page.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/config/fyp_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter FYP',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: FypRouter.generateRoute,
      initialRoute: WelcomePage.routeName,
    );
  }
}
