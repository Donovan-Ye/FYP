import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String content;

  const TextDivider({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Divider(
              height: 30,
              color: Color(0xff202020),
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            Text(
              content,
              style: TextStyle(color: Color(0xff898989), fontSize: 10),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
