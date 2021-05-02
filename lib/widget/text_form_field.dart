import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Icon icon;
  final Function vali;
  final bool isPass;

  const TextFormFieldWidget(
      {Key key,
      this.controller,
      this.labelText,
      this.hintText,
      this.icon,
      this.vali,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
        autofocus: false,
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
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
            filled: true,
            fillColor: Color(0xff2d2d2d),
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 12, color: Colors.white),
            hintText: hintText,
            icon: icon),
        validator: vali,
      ),
    );
  }
}
