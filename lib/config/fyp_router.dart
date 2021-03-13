import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/welcome/welcome_page.dart';
import 'package:fyp_yzj/pages/login/log_in_page.dart';
import 'package:fyp_yzj/pages/signup/sign_up_page.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_connecting_page.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:fyp_yzj/pages/emailVerificationCode/verification_code_page.dart';
import 'dart:developer' as developer;

class FypRouter {
  static Route generateRoute(RouteSettings settings) {
    developer.log('>>>> Route: ${settings.name}');
    switch (settings.name) {
      case WelcomePage.routeName:
        return WelcomePage.route();
      case LogInPage.routeName:
        return LogInPage.route();
      case SignUpPage.routeName:
        return SignUpPage.route();
      case TabNavigator.routeName:
        return TabNavigator.route();
      case FakeCallConnectingPage.routeName:
        return FakeCallConnectingPage.route();
      case FakeCallPage.routeName:
        return FakeCallPage.route();
      case VerificationCodePage.routeName:
        return VerificationCodePage.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
