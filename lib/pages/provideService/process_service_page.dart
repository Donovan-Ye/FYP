import 'dart:convert';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/model/applied_model.dart';
import 'package:fyp_yzj/model/friend_model.dart';
import 'package:fyp_yzj/pages/main/widget/add_friend_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProcessServicePage extends StatefulWidget {
  final String id;
  final String service_name;

  const ProcessServicePage({Key key, this.id, this.service_name})
      : super(key: key);

  @override
  _FriendListWidget createState() => _FriendListWidget();
}

class _FriendListWidget extends State<ProcessServicePage> {
  AppliedModel _applied;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getApplied();
  }

  void _getApplied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getApplied {
              getApplied {
                id
                appliedUser {
                  profile
                  username
                  password
                  email
                  gender
                  phone
                  isVerified
                  code
                }
                firstName
                lastName
                address
                address2
                city
                state
                zip
                phone
                description
                service_id
                status
              }
            }
          '''),
      ),
    );
    if (result.hasException) throw result.exception;
    if (result.data["getApplied"] != null) {
      setState(() {
        _applied = AppliedModel.fromJson(result.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Scrollbar(
        // 显示进度条
        child: _applied != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      _getContactListRow("Unprocessed"),
                      SizedBox(height: 8),
                      for (var i in _applied.services)
                        if (i.serviceId == widget.id &&
                            i.status == "processing")
                          _getAppliedListItem(context, i, profile: null),
                      SizedBox(height: 20),
                      _getContactListRow("Success"),
                      SizedBox(height: 8),
                      for (var i in _applied.services)
                        if (i.serviceId == widget.id && i.status == "success")
                          _getAppliedListItem(context, i, profile: null),
                      SizedBox(height: 20),
                      _getContactListRow("Failed"),
                      SizedBox(height: 8),
                      for (var i in _applied.services)
                        if (i.serviceId == widget.id && i.status == "failed")
                          _getAppliedListItem(context, i, profile: null)
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

  Widget _getAppliedListItem(BuildContext context, AppliedItem applied,
      {String profile}) {
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
                applied.appliedUser.profile == null
                    ? 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'
                    : applied.appliedUser.profile,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  EasyDialog(
                    height: 330,
                    title: Text(
                      "Application detail",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    contentList: [
                      _getDetailItem("First Name: ", applied.firstName),
                      SizedBox(height: 5),
                      _getDetailItem("Last Name: ", applied.lastName),
                      SizedBox(height: 5),
                      _getDetailItem("Phone: ", applied.phone),
                      SizedBox(height: 5),
                      _getDetailItem("Address: ", applied.address),
                      SizedBox(height: 5),
                      _getDetailItem("Address2: ", applied.address2),
                      SizedBox(height: 5),
                      _getDetailItem("City: ", applied.city),
                      SizedBox(height: 5),
                      _getDetailItem("State: ", applied.state),
                      SizedBox(height: 5),
                      _getDetailItem("Zip: ", applied.zip),
                      SizedBox(height: 5),
                      _getDetailItem("Description: ", ""),
                      Container(
                        child: Text(applied.description,
                            style: TextStyle(fontSize: 15)),
                      ),
                      SizedBox(height: 5),
                    ],
                  ).show(context);
                },
                child: Text(
                  applied.firstName + " " + applied.lastName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                applied.city,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          if (applied.status == "processing")
            IconButton(
              icon: Icon(
                Icons.check_circle,
                color: Color(0xff008AF3),
                size: 25,
              ),
              onPressed: () {
                _processService("success", applied.id);
              },
            ),
          if (applied.status == "processing")
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () {
                _processService("failed", applied.id);
              },
            ),
        ],
      ),
    );
  }

  void _processService(String status, String id) {
    EasyDialog(
        title: Text(
          "Process service",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Do you want to change the service status to " + status + "?",
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
                  _changeAccept(status, id);
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

  void _changeAccept(String status, String id) async {
    final SharedPreferences prefs = await _prefs;

    var response = await http.post(
      env['API_SERVER'] + "/service/processService",
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id, "status": status}),
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
      _getApplied();
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

  Widget _getContactListRow(String title) {
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
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDetailItem(String title, String content) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Container(
          child: Text(content, style: TextStyle(fontSize: 15)),
        )
      ],
    );
  }
}
