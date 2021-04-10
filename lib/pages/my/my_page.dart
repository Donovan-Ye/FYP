import 'dart:convert';
import 'dart:io';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/util/uploadFile.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final PageController _controller = PageController(
    initialPage: 0,
  );

  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  String profile =
      'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg';

  String id;
  String name;
  String email;
  String phone;
  String gender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getUser(\$username:String!) {
              getUser(username: \$username) {
                profile
                username
                email
                phone
                gender
              }
            }
          '''),
        variables: {'username': prefs.getString('name')},
      ),
    );
    if (result.hasException) throw result.exception;
    if (result.data["getUser"] != null) {
      setState(() {
        profile = result.data["getUser"]["profile"];
        name = result.data["getUser"]["username"];
        email = result.data["getUser"]["email"];
        phone = result.data["getUser"]["phone"];
        gender = result.data["getUser"]["gender"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff102439),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getProfileLine(),
            _getItemLine("ID", id, hasIcon: false),
            _getItemLine(
              "Name",
              name,
              hasIcon: true,
              controller: _nameController,
              columnName: "name",
            ),
            _getItemLine(
              "Email",
              email,
              hasIcon: true,
              controller: _emailController,
              columnName: "email",
            ),
            _getItemLine(
              "Phone",
              phone,
              hasIcon: true,
              controller: _phoneController,
              columnName: "phone",
            ),
            _getItemLine(
              "Gender",
              gender,
              hasIcon: true,
              controller: _genderController,
              columnName: "gender",
            ),
            SizedBox(height: 10),
            _getLogoutLine(),
          ],
        ),
      ),
    );
  }

  Widget _getProfileLine() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff041326),
        border: Border(
          bottom: BorderSide(color: Color(0xff1a1a1a), width: 1),
        ),
      ),
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 20),
          _getProfilePicture(),
          Expanded(child: Container()),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            ),
            onPressed: () async {
              final PickedFile file =
                  await _picker.getImage(source: ImageSource.gallery);
              setState(() {
                _imageFile = file;
                profile = null;
              });

              EasyLoading.show(status: 'Uploading...');

              bool isUploaded = await uploadFile(
                ".jpg",
                _imageFile != null
                    ? _imageFile.path
                    : "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
                context,
                isChangeProfile: true,
              );
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
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget _getProfilePicture() {
    return Container(
      width: 50,
      height: 50,
      child: ClipOval(
        child: profile == null
            ? _imageFile == null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                  )
                : Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.fitWidth,
                  )
            : CircleAvatar(
                backgroundImage: NetworkImage(profile),
              ),
      ),
    );
  }

  Widget _getItemLine(String title, String content,
      {bool hasIcon = true,
      TextEditingController controller,
      String columnName}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xff041326),
        border: Border(
          bottom: BorderSide(color: Color(0xff1a1a1a), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Container(
            width: 45,
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 30),
          Container(
            height: 30,
            child: Center(
              child: Text(
                content == null ? "Not Set" : content,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          Expanded(child: Container()),
          if (hasIcon)
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onPressed: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (context) =>
                      _getItemChangeArea(controller, columnName),
                );
              },
            ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget _getLogoutLine() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xff041326),
        border: Border(
          bottom: BorderSide(color: Color(0xff1a1a1a), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          GestureDetector(
            child: Text(
              "Log out",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              EasyDialog(
                  title: Text(
                    "Log out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 1.2,
                  ),
                  description: Text(
                    "Do you want to log out?",
                    textScaleFactor: 1.1,
                    textAlign: TextAlign.center,
                  ),
                  height: 130,
                  contentList: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new FlatButton(
                          padding: const EdgeInsets.only(top: 8.0),
                          textColor: Colors.lightBlue,
                          onPressed: () {
                            Get.offNamedUntil("/welcome", (route) => false);
                          },
                          child: new Text(
                            "Yes",
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
            },
          )
        ],
      ),
    );
  }

  Widget _getItemChangeArea(
      TextEditingController controller, String columnName) {
    return Material(
      color: Color(0xff222222),
      child: Column(
        children: [
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
                final SharedPreferences prefs = await _prefs;

                var updateBody = {"username": prefs.getString("name")};
                EasyLoading.show(status: 'Uploading...');

                setState(() {
                  switch (columnName) {
                    case "name":
                      {
                        name = controller.text;
                        updateBody["changedName"] = name;
                      }
                      break;
                    case "email":
                      {
                        email = controller.text;
                        updateBody["email"] = email;
                      }
                      break;
                    case "phone":
                      {
                        phone = controller.text;
                        updateBody["phone"] = phone;
                      }
                      break;
                    case "gender":
                      {
                        gender = controller.text;
                        updateBody["gender"] = gender;
                      }
                      break;
                    default:
                      {
                        print("something wrong!");
                      }
                      break;
                  }
                });
                controller.clear();
                var response = await http.post(
                  env['API_SERVER'] + "/user/changeUserInfo",
                  headers: {"Content-Type": "application/json"},
                  body: json.encode(updateBody),
                );

                var result = jsonDecode(response.body);

                EasyLoading.dismiss();
                Navigator.of(context).pop();
                print(result["status"]);
                if (result["status"] == true) {
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
                  prefs.setString("name", name);
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
              }),
        ],
      ),
    );
  }
}
