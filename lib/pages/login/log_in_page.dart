import 'package:fyp_yzj/pages/login/widget/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              TextFormFieldWidget(
                controller: _unameController,
                labelText: "Username",
                hintText: "username",
                icon: Icon(Icons.person, color: Colors.white),
                vali: (v) {
                  return v.trim().length > 0
                      ? null
                      : "Username can not be empty";
                },
              ),
              const SizedBox(height: 30),
              TextFormFieldWidget(
                controller: _pwdController,
                labelText: "Password",
                hintText: "password",
                icon: Icon(Icons.lock, color: Colors.white),
                vali: (v) {
                  return v.trim().length > 5
                      ? null
                      : "password should not less then 5";
                },
              ),
              const SizedBox(height: 30),
              Text("Trouble logging in?",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Color(0xff03DAC5))),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Log in"),
                          color: Color(0xff03DAC5),
                          textColor: Colors.white,
                          onPressed: _login),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAppBar() {
    return new AppBar(
      title: new Text('Log In'),
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
