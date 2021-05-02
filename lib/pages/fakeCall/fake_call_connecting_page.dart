import 'package:flutter/material.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:get/get.dart';

class FakeCallConnectingPage extends StatefulWidget {
  static const String routeName = '/fake_connect';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => FakeCallConnectingPage());
  }

  @override
  _FakeCallPage createState() => _FakeCallPage();
}

class _FakeCallPage extends State<FakeCallConnectingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fakeCall/iosFakeConnecting.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 80.0,
              left: 135,
              child: _handUp(
                Colors.red,
                Icons.call_end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handUp(Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(right: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(TabNavigator.routeName);
            },
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
