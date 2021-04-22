import 'dart:convert';
import 'dart:io';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp_yzj/widget/text_form_field.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/uploadFile.dart';

class AddServicePage extends StatefulWidget {
  @override
  _FriendListWidget createState() => _FriendListWidget();
}

class _FriendListWidget extends State<AddServicePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController _overviewController = new TextEditingController();
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _occupationController = new TextEditingController();
  TextEditingController _websiteController = new TextEditingController();
  String provider;
  String catergory;

  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  List<Asset> images = List<Asset>();
  List<File> fileImageArray = [];

  String _error = 'No Error Dectected';
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Container(
            margin: EdgeInsets.all(13),
            child: ElevatedButton(
              child: Text("Post"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)))),
              onPressed: () async {
                final SharedPreferences prefs = await _prefs;

                images.forEach((imageAsset) async {
                  final filePath = await FlutterAbsolutePath.getAbsolutePath(
                      imageAsset.identifier);

                  print(filePath);
                  File tempFile = File(filePath);
                  if (tempFile.existsSync()) {
                    fileImageArray.add(tempFile);
                  }
                });

                var response = await http.post(
                  env['API_SERVER'] + "/service/addService",
                  headers: {"Content-Type": "application/json"},
                  body: json.encode({
                    "name": _unameController.text.trim(),
                    "overview": _overviewController.text.trim(),
                    "provider": provider,
                    "category": catergory,
                    "address": _addressController.text.trim(),
                    "available_time": "Mon.~Fri. 8:00am - 5:00pm",
                    "title": _titleController.text.trim(),
                    "website": _websiteController.text.trim(),
                    "photos": [],
                    "provider_username": prefs.getString("name")
                  }),
                );

                var result = jsonDecode(response.body);

                print(result['status']);

                if (result['status'] == true) {
                  bool isUploaded;
                  EasyLoading.show(status: 'Uploading...');
                  fileImageArray.forEach((element) async {
                    isUploaded = await uploadFile(
                      ".jpg",
                      element.path,
                      context,
                      isPostService: true,
                      serviceId: result['id'],
                    );
                    if (!isUploaded) {
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
                  });

                  EasyLoading.dismiss();
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
                }
              },
            ),
          )
        ],
      ),
      body: Material(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Color(0xff2d2d2d),
                  child: Column(
                    children: [
                      TextField(
                        controller: _overviewController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 8,
                        decoration: InputDecoration.collapsed(
                          hintText: "Enter your overview here~",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width - 60,
                            child: Expanded(
                              child: buildGridView(),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.white,
                              ),
                              onPressed: loadAssets),
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "Catergory:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      GroupButton(
                        isRadio: false,
                        spacing: 10,
                        selectedColor: Colors.blue,
                        onSelected: (index, isSelected) => {
                          setState(() {
                            var arr = [
                              "legal aid",
                              "job",
                              "accommodation",
                              "psychotherapy",
                            ];
                            catergory = arr[index];
                          }),
                        },
                        buttons: [
                          "Legal aid",
                          "Job",
                          "Accommodation",
                          "Psychotherapy",
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "Provider:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      GroupButton(
                        isRadio: false,
                        spacing: 10,
                        selectedColor: Colors.blue,
                        onSelected: (index, isSelected) => {
                          setState(() {
                            var arr = [
                              "personal",
                              "government",
                              "organization",
                            ];
                            provider = arr[index];
                          }),
                        },
                        buttons: [
                          "Personal",
                          "Government",
                          "Organization",
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "Available time:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      GroupButton(
                        isRadio: false,
                        spacing: 10,
                        selectedButtons: [
                          "Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                        ],
                        selectedColor: Colors.blue,
                        onSelected: (index, isSelected) =>
                            print('$index button is selected'),
                        buttons: [
                          "Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday",
                          "Sunday",
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _getTextInputItem(_unameController, "Name", "name"),
                _getTextInputItem(_addressController, "Address", "address"),
                _getTextInputItem(_titleController, "Title", "title"),
                _getTextInputItem(
                    _occupationController, "Occupation", "occupation"),
                _getTextInputItem(
                    _websiteController, "Website(opt.)", "website"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTextInputItem(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: TextFormField(
          style: TextStyle(
            color: Colors.white,
          ),
          autofocus: false,
          controller: controller,
          obscureText: false,
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
            labelText: label,
            labelStyle: TextStyle(fontSize: 15, color: Colors.white),
            hintText: hint,
          ),
          validator: (v) {}),
    );
  }
}
