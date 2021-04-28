import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/model/path_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class PathPage extends StatefulWidget {
  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  PathModel _sharedPaths;
  String path;
  String username;
  Timer timer;

  final List<LatLng> points = <LatLng>[];
  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  String _mapStyle;
  Set<Marker> _markers = {};
  LatLng mapCenter;
  BitmapDescriptor customIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      points.clear();
      _markers.clear();
      _mapPolylines.clear();
      _polylineIdCounter = 1;
      _getUserInfo();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void getCurrentLocation() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)),
            'assets/images/icon/icon_white.png')
        .then((d) {
      customIcon = d;
      _markers.add(Marker(
        markerId: MarkerId(LatLng(double.parse(path.split(",")[0]),
                double.parse(path.split(",")[1]))
            .toString()),
        position: LatLng(
            double.parse(path.split(",")[0]), double.parse(path.split(",")[1])),
        infoWindow: InfoWindow(
          title: username,
        ),
        icon: customIcon,
      ));
    });

    setState(() {
      mapCenter = LatLng(
          double.parse(path.split(",")[0]), double.parse(path.split(",")[1]));
    });
  }

  void _add(LatLng lt) {
    points.add(lt);
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.yellow,
      width: 5,
      points: points,
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  void _getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getSharedPath{
              getSharedPath{
                username
                shared_username
                path
              }
            }
          '''),
      ),
    );
    if (result.hasException) throw result.exception;
    if (result.data["getSharedPath"] != null) {
      setState(() {
        _sharedPaths = PathModel.fromJson(result.data);
      });
      for (var p in _sharedPaths.sharedpaths) {
        if (p.sharedUsername == prefs.getString("name")) {
          for (var s in p.path) {
            List<String> pathArray = s.split(",");
            _add(
                LatLng(double.parse(pathArray[0]), double.parse(pathArray[1])));
            setState(() {
              path = s;
              username = p.username;
            });
          }
          getCurrentLocation();

          rootBundle.loadString('assets/map/map_style.txt').then((string) {
            _mapStyle = string;
          });
        }
      }
    }
  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  _filterPath() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _sharedPaths != null && mapCenter != null
            ? Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  polylines: Set<Polyline>.of(_mapPolylines.values),
                  initialCameraPosition: CameraPosition(
                    target: mapCenter,
                    zoom: 17.0,
                  ),
                  markers: _markers,
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
