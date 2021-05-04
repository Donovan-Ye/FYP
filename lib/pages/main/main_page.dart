import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/model/path_model.dart';
import 'package:fyp_yzj/pages/alarm/alarm_page.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:fyp_yzj/pages/main/widget/friend_list_widget.dart';
import 'package:fyp_yzj/pages/path/path_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fyp_yzj/pages/main/picker_data.dart';
import 'package:fyp_yzj/pages/countdown/countdown_page.dart';
import 'package:get/get.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:fyp_yzj/pages/main/widget/map_feature_icon.dart';
import 'package:fyp_yzj/pages/main/widget/floating_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:fyp_yzj/pages/video/video_list_page.dart';
import 'package:fyp_yzj/util/uploadFile.dart';

import 'package:path_provider/path_provider.dart';
import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _nameController = new TextEditingController();

  final Telephony telephony = Telephony.instance;

  PicovoiceManager _picovoiceManager;

  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  String _mapStyle;

  Position position;

  Set<Marker> _markers = {};

  LatLng mapCenter;
  BitmapDescriptor customIcon;

  Timer _timer;
  int _start = 10;

  bool _isPicoVoiceRunning = false;
  bool _isReceivingFriendPath = false;

  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  bool _isDrawRoute = false;
  Timer timer;
  Timer receivingFriendPathTimer;
  PathModel _sharedPaths;

  final List<LatLng> points = <LatLng>[];

  void _add(LatLng lt) {
    points.add(lt);
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 5,
      points: points,
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();

    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _initPicovoice();
    Timer(Duration(seconds: 1), () => {_showMainAlert()});
  }

  @override
  void dispose() {
    _timer.cancel();
    _picovoiceManager?.delete();
    super.dispose();
  }

  void _checkFriendPath() async {
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
        if (p.sharedUsername == prefs.getString("name") &&
            prefs.getBool("isShowPath") != true) {
          _showFriendPathAlert(p.username);
        }
      }
    }
  }

  void _showFriendPathAlert(String username) {
    EasyDialog(
        title: Text(
          "Your friend " + username + " want to share path with you",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Do you want accept? Once you accpet, Patronus will show the path.",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
        height: 200,
        contentList: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                padding: const EdgeInsets.only(top: 8.0),
                textColor: Colors.lightBlue,
                onPressed: () async {
                  Navigator.of(context).pop();

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  showBarModalBottomSheet(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => PathPage(),
                  );
                  prefs.setBool("isShowPath", true);
                },
                child: new Text(
                  "Accept",
                  textScaleFactor: 1.2,
                ),
              ),
              new FlatButton(
                padding: const EdgeInsets.only(top: 8.0),
                textColor: Colors.lightBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "Cancel",
                  textScaleFactor: 1.2,
                ),
              ),
            ],
          )
        ]).show(context);
  }

  _showMainAlert() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.getBool("isShowMainAlert") != true) {
      EasyDialog(
        title: Text(
          "Welcome to Patronus!",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        height: 250,
        contentList: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: [
                TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  text:
                      "The Patronus app wants to better protect your safety. So we used the function of voice recognition to trigger the alarm. But in order to protect your privacy, we have set a switch for voice recognition. If you want to turn on voice recognition, click ",
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.mic_off_outlined),
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ).show(context);
      prefs.setBool("isShowMainAlert", true);
    }
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
                child: mapCenter == null
                    ? Container(
                        color: Color(0xff102439),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : GoogleMap(
                        onMapCreated: _onMapCreated,
                        polylines: Set<Polyline>.of(_mapPolylines.values),
                        initialCameraPosition: CameraPosition(
                          target: mapCenter,
                          zoom: 17.0,
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
            child: FloatingIcons(
              icon1Tap: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FriendListWidget(),
                );
              },
              icon2: _isDrawRoute
                  ? Icon(Icons.location_on)
                  : Icon(Icons.location_off),
              icon2Color: _isDrawRoute ? Colors.red : Colors.white,
              icon2Tap: () async {
                if (!_isDrawRoute) {
                  _showLocationRouteAlert();
                  final SharedPreferences prefs = await _prefs;

                  setState(() {
                    timer =
                        Timer.periodic(Duration(seconds: 5), (Timer t) async {
                      Position res = await Geolocator.getCurrentPosition();
                      _add(LatLng(res.latitude, res.longitude));
                      setState(() {
                        mapCenter = LatLng(res.latitude, res.longitude);
                      });
                      if (_nameController.text != "") {
                        var response = await http.post(
                          env['API_SERVER'] + "/path/addToPath",
                          headers: {"Content-Type": "application/json"},
                          body: json.encode({
                            "username": prefs.getString("name"),
                            "shared_username": _nameController.text,
                            "path": res.latitude.toString() +
                                "," +
                                res.longitude.toString()
                          }),
                        );
                      }
                      _markers.clear();
                      _markers.add(Marker(
                        markerId: MarkerId(
                            LatLng(res.latitude, res.longitude).toString()),
                        position: LatLng(res.latitude, res.longitude),
                        infoWindow: InfoWindow(
                          title: 'I am here',
                        ),
                        icon: customIcon,
                      ));
                    });
                    _isDrawRoute = true;
                  });
                } else {
                  timer.cancel();
                  setState(() {
                    _isDrawRoute = false;
                  });
                }
              },
              icon3Tap: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _getItemChangeArea(_nameController),
                );
              },
              icon4Tap: () {
                if (_isPicoVoiceRunning) {
                  EasyLoading.showInfo('Stop voice listening.');
                  _picovoiceManager.stop();
                } else {
                  _showVoiceRecogAlert();
                  EasyLoading.showSuccess('Start voice listening.');
                  _picovoiceManager.start();
                }
                setState(() {
                  _isPicoVoiceRunning = !_isPicoVoiceRunning;
                });
              },
              icon4: _isPicoVoiceRunning
                  ? Icon(Icons.keyboard_voice)
                  : Icon(Icons.mic_off_outlined),
              icon4Color: _isPicoVoiceRunning ? Colors.red : Colors.white,
              icon5: _isReceivingFriendPath
                  ? Icon(Icons.hearing_outlined)
                  : Icon(Icons.hearing_disabled_outlined),
              icon5Color: _isReceivingFriendPath ? Colors.red : Colors.white,
              icon5Tap: () async {
                if (_isReceivingFriendPath) {
                  final SharedPreferences prefs = await _prefs;
                  receivingFriendPathTimer.cancel();
                  prefs.setBool("isShowPath", false);
                  EasyLoading.showInfo('Stop receiving friend path.');
                } else {
                  receivingFriendPathTimer =
                      Timer.periodic(Duration(seconds: 5), (Timer t) async {
                    _checkFriendPath();
                  });
                  EasyLoading.showSuccess('Start receiving friend path.');
                }
                setState(() {
                  _isReceivingFriendPath = !_isReceivingFriendPath;
                });
              },
            ),
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
            tap: () {
              _alarmDialog(context);
            },
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
            name: "List",
            color: Colors.blue,
            icon: Icons.list,
            context: context,
            tap: () async {
              Get.toNamed(VideoListPage.routeName);
            },
          ),
          MapFeatureIcon(
            name: "Video",
            color: Colors.blue,
            icon: Icons.video_call,
            context: context,
            tap: () async {
              final PickedFile file = await _picker.getVideo(
                  source: ImageSource.camera,
                  maxDuration: Duration(seconds: 300));
              if (file != null) {
                EasyLoading.show(status: 'Uploading...');

                bool isUploaded = await uploadFile(".mp4", file.path, context);

                EasyLoading.dismiss();
                if (isUploaded) {
                  EasyDialog(
                    title: Text(
                      "Success",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.2,
                    ),
                    description: Text(
                      "Upload successfully.",
                      textScaleFactor: 1.1,
                      textAlign: TextAlign.center,
                    ),
                  ).show(context);
                } else {
                  EasyDialog(
                    title: Text(
                      "Error",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.2,
                    ),
                    description: Text(
                      "Uploading failed. Please check your internet.",
                      textScaleFactor: 1.1,
                      textAlign: TextAlign.center,
                    ),
                  ).show(context);
                }

                setState(() {
                  _imageFile = file;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _showVoiceRecogAlert() async {
    final SharedPreferences prefs = await _prefs;
    // prefs.setBool("isShowVioceAlert", false);
    if (prefs.getBool("isShowVioceAlert") != true) {
      EasyDialog(
        title: Text(
          "First time to use Voice Recognition",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        height: 230,
        contentList: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: [
                TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  text:
                      "This is your first time using voice recognition. In order to allow you to use it normally when in danger.\n\nSo, we hope you will try it now. Please say \"",
                ),
                TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    text: "Patronus, help me."),
                TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    text: "\", to trigger a security alert."),
              ]),
            ),
          )
        ],
      ).show(context);
    }
  }

  _showLocationRouteAlert() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("isShowLocationAlert") != true) {
      EasyDialog(
        title: Text(
          "First time to use Location sharing",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        height: 230,
        contentList: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: [
                TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  text:
                      "After you open the location monitoring, we will record your moving path, and draw it in the map. \n If you want to close it, click ",
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                      ),
                      child: Icon(Icons.location_on),
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ).show(context);
      prefs.setBool("isShowLocationAlert", true);
    }
  }

  final SmsSendStatusListener listener = (SendStatus status) {
    print(status);
  };

  void _setSMS(String phone) {
    telephony.sendSms(
        to: phone,
        message:
            "HELP! I am in DANGER! Here is my position: http://maps.google.com/maps?q=" +
                mapCenter.latitude.toString() +
                "," +
                mapCenter.longitude.toString() +
                "&ll=" +
                mapCenter.latitude.toString() +
                "," +
                mapCenter.longitude.toString() +
                "&z=17. FROM Patronus.",
        statusListener: listener);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    print(res);

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)),
            'assets/images/icon/icon_white.png')
        .then((d) {
      customIcon = d;
      _markers.add(Marker(
        markerId: MarkerId(LatLng(res.latitude, res.longitude).toString()),
        position: LatLng(res.latitude, res.longitude),
        infoWindow: InfoWindow(
          title: 'I am here',
        ),
        icon: customIcon,
      ));
    });

    setState(() {
      mapCenter = LatLng(res.latitude, res.longitude);
    });
  }

  void _alarm() async {
    List<CameraDescription> cameras = await availableCameras();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmPage(
          cameras: cameras,
        ),
      ),
    );
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

  void _alarmDialog(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;

    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: 280,
        height: 188,
        title: Text(
          "Countdown to Alarm",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        descriptionPadding:
            EdgeInsets.only(left: 17.5, right: 17.5, bottom: 15.0),
        description: Text(
            "After the countdown is over, the current location will be sent to ${prefs.getString('currentEmergencyContact')}, and the video will be recorded and an alarm will be issued at the same time."),
        contentPadding:
            EdgeInsets.only(top: 12.0), // Needed for the button design
        contentList: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: TextButton(
              onPressed: () {
                _timer.cancel();
                _start = 10;
                Navigator.of(context).pop();
              },
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  void startTimer() {
                    const oneSec = const Duration(seconds: 1);
                    _timer = new Timer.periodic(
                      oneSec,
                      (Timer timer) {
                        if (_start != 0) {
                          setState(() {
                            _start--;
                          });
                        } else {
                          timer.cancel();
                          _timer.cancel();
                          _start = 10;
                          Navigator.of(context).pop();
                          _setSMS(prefs.getString('currentEmergencyContact'));
                          _alarm();
                        }
                        timer.cancel();
                      },
                    );
                  }

                  startTimer();
                  return Text(
                    "Cancel($_start)",
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ]).show(context);
  }

  void _initPicovoice() async {
    String keywordAsset = "assets/audio/patronus_android.ppn";
    String keywordPath = await _extractAsset(keywordAsset);
    String contextAsset = "assets/audio/fyp_en.rhn";
    String contextPath = await _extractAsset(contextAsset);

    try {
      _picovoiceManager = await PicovoiceManager.create(
          keywordPath, _wakeWordCallback, contextPath, _inferenceCallback);
      // _picovoiceManager.start();
    } on PvError catch (ex) {
      print(ex);
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    print("wake word detected!");
  }

  void _inferenceCallback(Map<String, dynamic> inference) async {
    print(inference);
    print(inference["isUnderstood"]);
    if (inference["isUnderstood"] && inference["intent"] == "searchHelp") {
      final SharedPreferences prefs = await _prefs;
      if (prefs.getBool("isShowVioceAlert") != true) {
        Navigator.of(context).pop();
        _showFriendAlert();
        _showVoiceRightAlert();
        prefs.setBool("isShowVioceAlert", true);
      } else {
        _alarmDialog(context);
      }
    }
  }

  _showFriendAlert() async {
    EasyDialog(
      title: Text(
        "Last thing before using Patronus",
        style: TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 1.2,
      ),
      height: 250,
      contentList: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(children: [
              TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                text:
                    "After the alarm being triggered, the help message including the location will be sent to your preset emergency contact. \n\nSo, if you want to preset one or more emergency contacts before using, click ",
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.hail),
                  ),
                ),
              ),
            ]),
          ),
        )
      ],
    ).show(context);
  }

  _showVoiceRightAlert() async {
    EasyDialog(
      topImage: AssetImage("assets/images/icon/patronus_part.jpg"),
      title: Text(
        "Congradutaion!",
        style: TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 1.2,
      ),
      height: 380,
      contentList: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(children: [
              TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                text:
                    "You already know how to use voice recognition.\n\nOf course, if you want to close it,",
              ),
              TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  text: "please click on the icon in the same location."),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red,
                    ),
                    child: Icon(Icons.keyboard_voice),
                  ),
                ),
              ),
            ]),
          ),
        )
      ],
    ).show(context);
  }

  Future<String> _extractAsset(String resourcePath) async {
    String resourceDirectory = (await getApplicationDocumentsDirectory()).path;
    String outputPath = '$resourceDirectory/$resourcePath';
    File outputFile = new File(outputPath);

    ByteData data = await rootBundle.load(resourcePath);
    final buffer = data.buffer;

    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return outputPath;
  }

  Widget _getItemChangeArea(TextEditingController controller) {
    return Material(
      color: Color(0xff222222),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Please enter the username you want to share your working path:",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Container(
            color: Color(0xff1A1A1A),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "unfilled",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(fontSize: 25),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
              child: Text('Save', style: TextStyle(fontSize: 15)),
              color: Color(0xff008AF3),
              padding: EdgeInsets.fromLTRB(130, 14, 130, 14),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onPressed: () async {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
