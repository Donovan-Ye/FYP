import 'dart:convert';

import 'package:first_app/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:first_app/pages/log_in_page.dart';
import 'package:first_app/pages/sign_up_page.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  _log() {
    print("点击了按钮");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Patronus'),
        leading: new IconButton(
            icon: new Icon(Icons.contact_page),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage("assets/images/alarm.jpg"),
            ),
          ),
          Positioned(
            bottom: 18.0,
            left: 150,
            child: _map_icon(
              "hand up",
              Colors.red,
              Icons.call_end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _map_icon(String name, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(right: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TabNavigator();
              }));
            },
            child: new Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 15),
          )
        ],
      ),
    );
  }
}
