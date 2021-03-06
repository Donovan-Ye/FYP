import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/alarm/alarm_page.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position position;
  LatLng _center = const LatLng(52.261268, -7.150473);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      // _center = LatLng(res.latitude, res.longitude);
    });
  }

  void _alarm() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AlarmPage();
    }));
  }

  void _fakeCall() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FakeCallPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        toolbarHeight: 45,
        title: new Text('Patronus'),
        leading: new IconButton(
            icon: new Icon(
              Icons.contact_page,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        backgroundColor: Color(0xff191919),
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Container(
            color: Color(0xff303030),
            padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _map_icon(
                  "Alarm",
                  Color(0xffff3d2f),
                  Icons.notifications,
                  tap: _alarm,
                ),
                _map_icon(
                  "Fake",
                  Colors.blue,
                  Icons.call,
                  tap: _fakeCall,
                ),
                _map_icon(
                  "demo",
                  Colors.blue,
                  Icons.brightness_high,
                ),
                _map_icon(
                  "demo",
                  Colors.blue,
                  Icons.screen_rotation,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: <Marker>[
                Marker(
                    markerId: MarkerId("me"),
                    position: _center,
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(title: "me"))
              ].toSet(),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _map_icon(String name, Color color, IconData icon, {Function tap}) {
    return Container(
      height: 65,
      width: 65,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: tap,
            child: new Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
