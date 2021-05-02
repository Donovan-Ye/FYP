import 'dart:convert';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/model/applied_model.dart';
import 'package:fyp_yzj/model/service_model.dart';
import 'package:fyp_yzj/pages/provideService/add_service_page.dart';
import 'package:fyp_yzj/pages/provideService/process_service_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class ProvideServicePage extends StatefulWidget {
  @override
  _ProvideServicePageState createState() => _ProvideServicePageState();
}

class _ProvideServicePageState extends State<ProvideServicePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AppliedModel _applied;
  ServiceModel _services;
  String username;

  final PageController _controller = PageController(
    initialPage: 0,
  );

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getServices();
    _getApplied();
  }

  void _getServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getServices {
              getServices {
                id
                is_deleted
                name
                overview
                poster_path
                release_date
                provider
                category
                address
                available_time
                profile
                title
                occupation
                website
                is_professional
                provider_username
              }
            }
          '''),
      ),
    );
    if (result.hasException) throw result.exception;
    if (result.data["getServices"] != null) {
      setState(() {
        _services = ServiceModel.fromJson(result.data);
        username = prefs.getString("name");
      });
    }
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

  PageController _pageController = PageController(initialPage: 1);
  int currentIndex = 1;

  String url = "http://192.168.0.150:3000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Services"),
        backgroundColor: Color(0xff060606),
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddServicePage(),
                ).then((value) => {_getServices()});
              })
        ],
      ),
      body: _services == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (!_services.services.any((s) =>
                      s.provider_username == username && s.is_deleted != true))
                    _getNotProvidedWidget(),
                  for (var s in _services.services)
                    if (s.provider_username == username && s.is_deleted != true)
                      _getAppliedItem(s.poster_path, s.name, s.release_date,
                          s.overview, s.id)
                ],
              ),
            ),
    );
  }

  Widget _getNotProvidedWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You haven't provided any help yet~",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(height: 7),
              Text(
                "Publish services and give others a little warmth.",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              SizedBox(height: 7),
              ElevatedButton(
                child: Text("Provide help now"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.blue)))),
                onPressed: () async {
                  showBarModalBottomSheet(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddServicePage(),
                  ).then((value) => {_getServices()});
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "Good Services",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 20,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              for (var s in _services.services)
                if (s.is_deleted != true)
                  _getAppliedItem(
                      s.poster_path, s.name, s.release_date, s.overview, s.id,
                      isExample: true),
              SizedBox(height: 100)
            ],
          ),
        )
      ],
    );
  }

  Widget _getAppliedItem(
      String poster, String name, String data, String overview, String id,
      {bool isExample = false}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          ExpansionCard(
            borderRadius: 20,
            background: ClipRect(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.network(
                    poster,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    data,
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 7),
                child: Text(overview,
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
              SizedBox(height: 10),
              if (!isExample)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("Delete"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        _deleteService(id);
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                )
            ],
          ),
          if (!isExample)
            Positioned(
              right: 5,
              child: IconButton(
                icon: Icon(
                  Icons.mark_email_unread,
                  color: Colors.white,
                ),
                onPressed: () {
                  showBarModalBottomSheet(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ProcessServicePage(
                      id: id,
                      service_name: name,
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  void _deleteService(String id) {
    EasyDialog(
        title: Text(
          "Delete service",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "Do you want to delete this service? If you do so, all the application will be rejected!",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
        height: 180,
        contentList: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                padding: const EdgeInsets.only(top: 8.0),
                textColor: Colors.lightBlue,
                onPressed: () async {
                  for (var s in _applied.services) {
                    if (s.serviceId == id) _rejectService(s.id);
                  }
                  var response = await http.post(
                    env['API_SERVER'] + "/service/deleteService",
                    headers: {"Content-Type": "application/json"},
                    body: json.encode({"id": id}),
                  );

                  var result = jsonDecode(response.body);

                  print(result['status']);
                  Navigator.of(context).pop();

                  if (result["status"]) {
                    EasyDialog(
                      title: Text(
                        "Success",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.2,
                      ),
                      description: Text(
                        "Delete successfully.",
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.center,
                      ),
                    ).show(context);
                    _getServices();
                  } else {
                    EasyDialog(
                      title: Text(
                        "Error",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.2,
                      ),
                      description: Text(
                        "Delete failed. Please check your internet.",
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.center,
                      ),
                    ).show(context);
                  }
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

  void _rejectService(String id) async {
    var response = await http.post(
      env['API_SERVER'] + "/service/processService",
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id, "status": "failed"}),
    );

    var result = jsonDecode(response.body);
    if (result["status"]) {
      _getApplied();
    } else {}
  }
}
