import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_yzj/pages/signup/gender_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTypePage extends StatefulWidget {
  static const String routeName = '/usertype';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => UserTypePage());
  }

  @override
  _UserTypePageState createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
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
              children: [
                Text(
                  "Select User Type",
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
              children: [
                Text(
                  "Plese choose your user type",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getUserTypeButton(Icons.person, "Personal"),
                SizedBox(width: 10),
                _getUserTypeButton(Icons.group, "Organization"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getUserTypeButton(Icons.apartment, "Government"),
                SizedBox(width: 10),
                _getUserTypeButton(Icons.privacy_tip, "Not now"),
              ],
            ),
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
                          "Please choose a user type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.2,
                        ),
                        description: Text(
                            "Before you try to sign up, please state who you are."),
                      ).show(context);
                    } else {
                      final SharedPreferences prefs = await _prefs;
                      prefs.setString("userType", choosedOne);
                      Get.toNamed(GenderPage.routeName);
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

  Widget _getUserTypeButton(IconData icon, String name) {
    return Stack(
      children: [
        ElevatedButton(
          child: Center(
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: choosedOne == name ? Colors.white : Color(0xff1EBEDA),
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
                borderRadius: BorderRadius.circular(18.0),
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
