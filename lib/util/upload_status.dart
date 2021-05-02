import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UploadStatus {
  bool success;
  String message;

  bool isUploaded;

  Future<void> call(String url, String filePath) async {
    try {
      var response;
      if (filePath.startsWith("https://")) {
        Uint8List bytes = (await NetworkAssetBundle(Uri.parse(
                    "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg"))
                .load(
                    "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg"))
            .buffer
            .asUint8List();
        response = await http.put(url, body: bytes);
      } else {
        response = await http.put(url, body: File(filePath).readAsBytesSync());
      }

      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading video');
    }
  }
}
