import 'dart:convert';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/model/friend_model.dart';
import 'package:fyp_yzj/pages/main/widget/add_friend_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FriendListWidget extends StatefulWidget {
  @override
  _FriendListWidget createState() => _FriendListWidget();
}

class _FriendListWidget extends State<FriendListWidget> {
  FriendModel _friends;
  FriendItem _currentContact;
  bool _isReady = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVideos();
  }

  void _getVideos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getUser(\$username:String!) {
              getUser(username: \$username) {
                friends{
                  name
                  phone
                  profile
                }
                currentFriend{
                  name
                  phone
                  profile
                }
              }
            }
          '''),
        variables: {'username': prefs.getString('name')},
      ),
    );
    if (result.hasException) throw result.exception;
    if (result.data["getUser"] != null) {
      setState(() {
        _friends = FriendModel.fromJson(result.data["getUser"]);
      });
    }
    if (result.data["getUser"]["currentFriend"] != null) {
      setState(() {
        _currentContact =
            FriendItem.fromJson(result.data["getUser"]["currentFriend"]);
        prefs.setString("currentEmergencyContact", _currentContact.phone);
      });
    }
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Scrollbar(
        // 显示进度条
        child: _isReady
            ? SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Color(0xff1a1a1a), width: 1),
                          ),
                        ),
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Text("Current emergency contact:",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      _getFriendListItem(
                        context,
                        _currentContact == null
                            ? "Not set"
                            : _currentContact.name,
                        _currentContact == null
                            ? "Not set"
                            : _currentContact.phone,
                        profile: _currentContact == null
                            ? "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg"
                            : _currentContact.profile,
                        isCurrent: true,
                      ),
                      SizedBox(height: 15),
                      _getContactListRow(),
                      for (var i in _friends.friends)
                        if (_currentContact == null ||
                            i.phone != _currentContact.phone)
                          _getFriendListItem(context, i.name, i.phone,
                              profile: i.profile)
                    ],
                  ),
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

  Widget _getFriendListItem(BuildContext context, String name, String phone,
      {String profile, bool isCurrent = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff1a1a1a), width: 1),
        ),
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                profile == null
                    ? 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'
                    : profile,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Text(
                phone,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          IconButton(
            icon: Icon(
              Icons.circle_notifications,
              color: isCurrent ? Colors.red : Color(0xff008AF3),
              size: 25,
            ),
            onPressed: () {
              _changeCurrent(phone);
            },
          ),
        ],
      ),
    );
  }

  void _changeCurrent(String phone) {
    EasyDialog(
        title: Text(
          "Replace Emergency Contact",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Do you want to replace Current Emergency Contact with this one?",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
        height: 150,
        contentList: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                padding: const EdgeInsets.only(top: 8.0),
                textColor: Colors.lightBlue,
                onPressed: () {
                  _changeAccept(phone);
                  Navigator.of(context).pop();
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

  void _changeAccept(String phone) async {
    final SharedPreferences prefs = await _prefs;

    var response = await http.post(
      env['API_SERVER'] + "/friend/changeCurrent",
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": prefs.getString("name"),
        "phone": phone,
      }),
    );

    var result = jsonDecode(response.body);
    if (result["status"]) {
      EasyDialog(
        title: Text(
          "Success",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Change successfully.",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
      ).show(context);
      _getVideos();
    } else {
      EasyDialog(
        title: Text(
          "Error",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Change failed. Please check your internet.",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
      ).show(context);
    }
  }

  Widget _getContactListRow() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff1a1a1a), width: 1),
        ),
      ),
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
            "contact list:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.person_add_alt,
              color: Color(0xff008AF3),
              size: 20,
            ),
            onPressed: () {
              showBarModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => AddFriendWidget(),
              ).then((value) => {_getVideos()});
            },
          ),
        ],
      ),
    );
  }
}
