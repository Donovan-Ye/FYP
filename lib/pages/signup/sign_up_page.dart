import 'package:fyp_yzj/pages/emailVerificationCode/verification_code_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:fyp_yzj/widget/text_form_field.dart';
import 'package:fyp_yzj/pages/signup/widget/log_in_reminder.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  String countryCode = "+353";

  GlobalKey<FormState> _formKey = GlobalKey();
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
          Container(
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: new OutlineInputBorder(
                  gapPadding: 1.0,
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Color(0xff008AF3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff008AF3),
                  ),
                ),
                labelStyle: TextStyle(fontSize: 12, color: Colors.white),
                hintText: "Phone number",
                filled: true,
                fillColor: Color(0xff2d2d2d),
              ),
              controller: _phoneController,
              initialCountryCode: "IE",
              countryCodeTextColor: Colors.white,
              style: TextStyle(color: Colors.white),
              onChanged: (phone) {
                print(countryCode + " " + _phoneController.text);
              },
              onCountryChanged: (phone) {
                print('Country code changed to: ' + phone.countryCode);
                setState(() {
                  countryCode = phone.countryCode;
                });
              },
            ),
          ),
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
    final SharedPreferences prefs = await _prefs;

    if ((_formKey.currentState as FormState).validate()) {
      final result = await GraphqlClient.getNewClient()
          .mutate(MutationOptions(documentNode: gql('''
                                mutation updateData(\$un: String!, \$pw: String!,\$em: String!,\$userType: String!,\$gender: String!,\$phone: String!) {
                                  updateData(username: \$un, password: \$pw, email: \$em, userType: \$userType, gender: \$gender, phone: \$phone) {
                                    status
                                    message
                                  }
                                }
                              '''), variables: {
        'un': _unameController.text.trim(),
        'pw': _pwdController.text.trim(),
        'em': _emailController.text.trim(),
        'userType': prefs.getString("userType"),
        'gender': prefs.getString("gender"),
        'phone': countryCode + " " + _phoneController.text
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
