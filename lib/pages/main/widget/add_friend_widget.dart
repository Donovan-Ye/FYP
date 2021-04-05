import 'dart:io';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp_yzj/widget/text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../util/uploadFile.dart';

class AddFriendWidget extends StatefulWidget {
  @override
  _FriendListWidget createState() => _FriendListWidget();
}

class _FriendListWidget extends State<AddFriendWidget> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _uphoneController = new TextEditingController();

  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _getProfile(),
            SizedBox(height: 20),
            TextFormFieldWidget(
              controller: _unameController,
              labelText: "Name",
              hintText: "Name",
              icon: Icon(Icons.people, color: Colors.white),
              vali: (v) {},
            ),
            SizedBox(height: 10),
            TextFormFieldWidget(
              controller: _uphoneController,
              labelText: "Phone number",
              hintText: "Phone number",
              icon: Icon(Icons.phone_android, color: Colors.white),
              vali: (v) {},
            ),
            SizedBox(height: 10),
            RaisedButton(
                child: Text('Add', style: TextStyle(fontSize: 15)),
                color: Color(0xff008AF3),
                padding: EdgeInsets.fromLTRB(140, 14, 140, 14),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                onPressed: () async {
                  EasyLoading.show(status: 'Uploading...');

                  bool isUploaded = await uploadFile(
                    ".jpg",
                    _imageFile != null
                        ? _imageFile.path
                        : "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
                    context,
                    friendName: _unameController.text.trim(),
                    friendPhone: _uphoneController.text.trim(),
                  );
                  EasyLoading.dismiss();
                  if (isUploaded) {
                    EasyDialog(
                      title: Text(
                        "Success",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.2,
                      ),
                      description: Text(
                        "Upload successfully.",
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.center,
                      ),
                    ).show(context);
                  } else {
                    EasyDialog(
                      title: Text(
                        "Error",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.2,
                      ),
                      description: Text(
                        "Uploading failed. Please check your internet.",
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.center,
                      ),
                    ).show(context);
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _getProfile() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          child: ClipOval(
            child: _imageFile == null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                  )
                : Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.fitWidth,
                  ),
          ),
        ),
        Positioned(
          right: -10,
          bottom: -10,
          child: IconButton(
            icon: Icon(
              Icons.sync,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () async {
              final PickedFile file =
                  await _picker.getImage(source: ImageSource.gallery);
              setState(() {
                _imageFile = file;
              });
            },
          ),
        ),
      ],
    );
  }
}
