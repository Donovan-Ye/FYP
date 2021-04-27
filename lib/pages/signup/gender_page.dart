import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/signup/sign_up_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderPage extends StatefulWidget {
  final String opener;
  static const String routeName = '/gender';

  const GenderPage({Key key, this.opener}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => GenderPage());
  }

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String choosedOne = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text(
          '',
          style: TextStyle(fontSize: 18),
        ),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Gender",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Plese choose your gendaer",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getGenderButton(
                  AssetImage("assets/images/icon/baseline_male_white_48.png"),
                  "Male",
                  Color(0xff1179FC),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getGenderButton(
                  AssetImage("assets/images/icon/baseline_female_white_48.png"),
                  "Female",
                  Color(0xffE91F8A),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Icon(
                    Icons.arrow_right_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(70, 70)),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff192438)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(
                          color: Color(0xff192438),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (choosedOne == null) {
                      EasyDialog(
                          title: Text(
                            "You didn't choose your gender",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.2,
                          ),
                          height: 190,
                          contentList: [
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(children: [
                                  TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    text:
                                        "We notice that you didn't choose your gender, if you don't want to show your gender, we will set your gender to ",
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    text: "Not set",
                                  ),
                                ]),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new FlatButton(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  textColor: Colors.lightBlue,
                                  onPressed: () async {
                                    // Navigator.of(context).pop();
                                    final SharedPreferences prefs =
                                        await _prefs;
                                    prefs.setString("gender", "Not set");
                                    if (widget.opener == "my") {
                                      Get.back();
                                      Get.back();
                                    } else
                                      Get.toNamed(SignUpPage.routeName);
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
                    } else {
                      final SharedPreferences prefs = await _prefs;
                      prefs.setString("gender", choosedOne);
                      if (widget.opener == "my") {
                        print("HJHHHH");
                        Navigator.of(context).pop();
                      } else {
                        print("HJHHHadasdasdasdasdH");
                        Get.toNamed(SignUpPage.routeName);
                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getGenderButton(AssetImage icon, String name, Color color) {
    return Stack(
      children: [
        ElevatedButton(
          child: Center(
            child: Column(
              children: [
                Image(
                  image: icon,
                  width: 60,
                  color: choosedOne == name ? Colors.white : color,
                ),
                SizedBox(height: 11),
                Text(name)
              ],
            ),
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(
                MediaQuery.of(context).size.width / 2 - 30,
                MediaQuery.of(context).size.width / 2 - 30)),
            backgroundColor: MaterialStateProperty.all(
                choosedOne == name ? Color(0xff2946FE) : Color(0xff192438)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: BorderSide(
                  color: choosedOne == name
                      ? Color(0xff2946FE)
                      : Color(0xff192438),
                ),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              choosedOne = name;
            });
          },
        ),
        if (choosedOne == name)
          Positioned(
            top: 10,
            right: 10,
            child: Icon(Icons.check_circle, color: Colors.white),
          )
      ],
    );
  }
}
