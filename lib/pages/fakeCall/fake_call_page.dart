import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_connecting_page.dart';
import 'package:fyp_yzj/pages/main/main_page.dart';

class FakeCallPage extends StatefulWidget {
  @override
  _FakeCallPage createState() => _FakeCallPage();
}

class _FakeCallPage extends State<FakeCallPage> {
  void _dcline() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MainPage();
    }));
  }

  void _accept() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FakeCallConnectingPage();
    }));
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
