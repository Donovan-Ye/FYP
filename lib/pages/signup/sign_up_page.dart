import 'package:fyp_yzj/pages/emailVerificationCode/verification_code_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/widget/text_form_field.dart';
import 'package:fyp_yzj/pages/signup/widget/log_in_reminder.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SignUpPage());
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text(
          'Sign Up',
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
            Expanded(
              child: _getSignUpMainArea(),
            ),
            LogInReminder()
          ],
        ),
      ),
    );
  }

  Widget _getSignUpMainArea() {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidate: true, //开启自动校验
      child: Column(
        children: <Widget>[
          TextFormFieldWidget(
            controller: _emailController,
            labelText: "Email",
            hintText: "Email",
            icon: Icon(Icons.email, color: Colors.white),
            vali: (v) {
              RegExp emailReg = new RegExp(
                  r"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$");
              return emailReg.hasMatch(v) ? null : "Email format is wrong";
            },
          ),
          const SizedBox(height: 10),
          TextFormFieldWidget(
            controller: _unameController,
            labelText: "Username",
            hintText: "Username",
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
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 15),
                  ),
                  color: Color(0xff008AF3),
                  textColor: Colors.white,
                  onPressed: _signUp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    if ((_formKey.currentState as FormState).validate()) {
      final result = await GraphqlClient.getNewClient()
          .mutate(MutationOptions(documentNode: gql('''
                                mutation updateData(\$un: String!, \$pw: String!,\$em: String!) {
                                  updateData(username: \$un, password: \$pw, email: \$em) {
                                    status
                                    message
                                  }
                                }
                              '''), variables: {
        'un': _unameController.text.trim(),
        'pw': _pwdController.text.trim(),
        'em': _emailController.text.trim()
      }));
      if (result.hasException) throw result.exception;
      print(result.data);
      print(_emailController.text.trim());
      print(_unameController.text);
      print(_pwdController.text);
      if (result.data["updateData"]["status"]) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodePage(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error!'),
                  content: Text(result.data["updateData"]["message"]),
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
