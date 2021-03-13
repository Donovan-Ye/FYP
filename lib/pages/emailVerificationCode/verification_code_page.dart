import 'package:fyp_yzj/pages/login/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:fyp_yzj/navigator/tab_navigator.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;

  const VerificationCodePage({Key key, this.email}) : super(key: key);

  static const String routeName = '/email';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => VerificationCodePage());
  }

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  String verfificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 80),
          Text(
            "Enter the verification code",
            textAlign: TextAlign.right,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Please enter the verification code we send to " + widget.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            child: VerificationBox(
              count: 4,
              itemWidget: 60,
              textStyle: TextStyle(color: Colors.lightBlue, fontSize: 20),
              borderColor: Colors.grey,
              focusBorderColor: Colors.lightBlue,
              onSubmitted: (value) {
                print('$value');
                verfificationCode = value;
              },
            ),
          ),
          SizedBox(height: 20),
          RaisedButton(
            padding: EdgeInsets.fromLTRB(170, 15, 170, 15),
            child: Text(
              "Go",
              style: TextStyle(fontSize: 15),
            ),
            color: Color(0xff03DAC5),
            textColor: Colors.white,
            onPressed: () async {
              if (verfificationCode.length == 4) {
                print('hi');
                final result = await GraphqlClient.getNewClient()
                    .query(QueryOptions(documentNode: gql('''
                  query verifyCode(\$em: String!,\$cd:String!){
                    verifyCode(email: \$em, code: \$cd) {
                      status,
                      message
                    }
                  }
               '''), variables: {'em': widget.email, 'cd': verfificationCode}));
                if (result.hasException) throw result.exception;
                print(result.data);
                if (result.data["verifyCode"]["status"]) {
                  Get.toNamed(TabNavigator.routeName);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Error!'),
                            content: Text(result.data["verifyCode"]["message"]),
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
            },
          )
        ],
      ),
    );
  }
}
