import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fyp_yzj/pages/alarm/alarm_page.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fyp_yzj/pages/main/picker_data.dart';
import 'package:fyp_yzj/pages/countdown/countdown_page.dart';
import 'package:get/get.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fyp_yzj/pages/main/widget/map_feature_icon.dart';
import 'package:fyp_yzj/pages/main/widget/floating_icons.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  String _mapStyle;

  Position position;

  Set<Marker> _markers = {};

  LatLng _center = const LatLng(52.261268, -7.150473);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentLocation();

    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor customIcon;

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/icon/icon_white.png')
        .then((d) {
      customIcon = d;

      _markers.add(Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: 'I am here',
        ),
        icon: customIcon,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: _markers,
                ),
              ),
              Container(
                height: 60,
                color: Color(0xff102439),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: FloatingIcons(),
          )
        ],
      ),
      floatingActionButton: FabCircularMenu(
        alignment: Alignment.bottomLeft,
        fabColor: Colors.white,
        fabOpenColor: Colors.black,
        fabMargin: EdgeInsets.fromLTRB(0, 0, 10, 100),
        fabOpenIcon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        ringColor: Color(0xff202A30),
        children: <Widget>[
          MapFeatureIcon(
            name: "Alarm",
            color: Color(0xffcc0000),
            icon: Icons.notifications,
            context: context,
            tap: _alarm,
          ),
          MapFeatureIcon(
            name: "Fake",
            color: Color(0xff3333cc),
            icon: Icons.call,
            context: context,
            tap: () {
              showPickerArray(context);
            },
          ),
          MapFeatureIcon(
            name: "demo",
            color: Colors.blue,
            icon: Icons.brightness_high,
            context: context,
          ),
          MapFeatureIcon(
            name: "demo",
            color: Colors.blue,
            icon: Icons.screen_rotation,
            context: context,
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(res.latitude, res.longitude);
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

  void _countDown(int hour, int minute, int second) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CountdownPage(
        hour: hour,
        minute: minute,
        second: second,
      );
    }));
  }

  showPickerArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData2),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0, 0, 0],
        title: Text("Setting countdown time"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: FlatButton(
            onPressed: () {
              Get.toNamed(FakeCallPage.routeName);
            },
            child: Text("Right Now")),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          _countDown(
            int.parse(picker.getSelectedValues()[0]),
            int.parse(picker.getSelectedValues()[1]),
            int.parse(picker.getSelectedValues()[2]),
          );
        }).showDialog(context);
  }
}
