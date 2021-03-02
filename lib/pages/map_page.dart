import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:first_app/pages/alarm_page.dart';
import 'package:first_app/pages/sign_up_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _map_icon(
                  "Alarm",
                  Color(0xffff3d2f),
                  Icons.notifications,
                ),
                _map_icon(
                  "Fake",
                  Colors.blue,
                  Icons.call,
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

  Widget _map_icon(String name, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(right: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AlarmPage();
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
