import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_connecting_page.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:get/get.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playRing();
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

  void _dcline() async {
    await audioPlayer.stop();

    Get.toNamed(TabNavigator.routeName);
  }

  void _accept() async {
    await audioPlayer.stop();

    Get.toNamed(FakeCallConnectingPage.routeName);
  }

  void _playRing() async {
    final bundleDir = 'assets/audio';
    final assetName = 'call_sound.mp3';
    final localDir = await getApplicationDocumentsDirectory();
    final localAssetFile = await copyLocalAsset(localDir, bundleDir, assetName);
    await audioPlayer.play(localAssetFile.path, isLocal: true);
  }

  Future<File> copyLocalAsset(
      Directory localDir, String bundleDir, String assetName) async {
    final data = await rootBundle.load('$bundleDir/$assetName');
    final bytes = data.buffer.asUint8List();
    final localAssetFile = File('${localDir.path}/$assetName');
    await localAssetFile.writeAsBytes(bytes, flush: true);
    return localAssetFile;
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
