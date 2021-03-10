import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_connecting_page.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:get/get.dart';

class FakeCallPage extends StatefulWidget {
  static const String routeName = '/fake_call';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => FakeCallPage());
  }

  @override
  _FakeCallPage createState() => _FakeCallPage();
}

class _FakeCallPage extends State<FakeCallPage> {
  void _dcline() {
    Get.toNamed(TabNavigator.routeName);
  }

  void _accept() {
    Get.toNamed(FakeCallConnectingPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fakeCall/iosFakeCall.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 95.0,
              left: 49,
              child: _fakeCallButton(
                Colors.red,
                Icons.call_end,
                _dcline,
              ),
            ),
            Positioned(
              bottom: 95.0,
              right: 41,
              child: _fakeCallButton(
                Colors.green,
                Icons.call,
                _accept,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fakeCallButton(Color color, IconData icon, Function tap) {
    return Container(
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(right: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: tap,
            child: new Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
