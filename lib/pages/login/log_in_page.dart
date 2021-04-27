import 'package:fyp_yzj/pages/signup/user_type_page.dart';
import 'package:fyp_yzj/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/widget/text_divider.dart';
import 'package:fyp_yzj/pages/signup/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => LogInPage());
  }

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Expanded(
            child: _getLogInMainWidget(),
          )),
    );
  }

  Widget _getLogInMainWidget() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormFieldWidget(
            controller: _unameController,
            labelText: "Username",
            hintText: "username",
            icon: Icon(Icons.person, color: Colors.white),
            vali: (v) {
              return v.trim().length > 0 ? null : "Username can not be empty";
            },
          ),
          const SizedBox(height: 10),
          TextFormFieldWidget(
            controller: _pwdController,
            labelText: "Password",
            hintText: "password",
            icon: Icon(Icons.lock, color: Colors.white),
            isPass: true,
            vali: (v) {
              return v.trim().length > 5
                  ? null
                  : "password should not less then 5";
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                    child: Text('Log In', style: TextStyle(fontSize: 15)),
                    color: Color(0xff008AF3),
                    padding: EdgeInsets.fromLTRB(130, 14, 130, 14),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onPressed: _login),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextDivider(content: "OR"),
          const SizedBox(height: 10),
          Container(
            child: GestureDetector(
              child: Text(
                "Don't have account? Sign up",
                style: TextStyle(color: Color(0xff008AF3), fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.toNamed(UserTypePage.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBar() {
    return new AppBar(
      title: new Text(
        'Log In',
        style: TextStyle(fontSize: 18),
      ),
      leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          }),
      backgroundColor: Colors.black,
    );
  }

  void _login() async {
    if ((_formKey.currentState as FormState).validate()) {
      final result = await GraphqlClient.getNewClient().query(QueryOptions(
          documentNode: gql('''
                                query fetchObjectData(\$un: String!, \$pw: String!) {
                                  fetchObjectData(username: \$un, password: \$pw) {
                                    status
                                    message
                                  }
                                }
                              '''),
          variables: {
            'un': _unameController.text.trim(),
            'pw': _pwdController.text.trim()
          }));
      if (result.hasException) throw result.exception;
      print(result.data);
      print(_unameController.text);
      print(_pwdController.text);
      if (result.data["fetchObjectData"]["status"]) {
        final SharedPreferences prefs = await _prefs;
        prefs.clear();
        prefs.setString("name", _unameController.text.trim());
        Get.toNamed(TabNavigator.routeName);
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error!'),
                  content: Text(result.data["fetchObjectData"]["message"]),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ));
      }
    }
  }
}
