import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fyp_yzj/util/upload_status.dart';
import 'package:fyp_yzj/util/generate_image_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> uploadFile(
    String fileType, String filePath, BuildContext context) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  GenerateImageUrl generateImageUrl = GenerateImageUrl();
  await generateImageUrl.call(fileType, prefs.getString('name'));

  String uploadUrl;
  String downloadUrl;
  if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
    uploadUrl = generateImageUrl.uploadUrl;
    downloadUrl = generateImageUrl.downloadUrl;
    print(uploadUrl);
    print(downloadUrl);
  } else {
    throw generateImageUrl.message;
  }

  bool isUploaded = await _upload(context, uploadUrl, File(filePath));
  return isUploaded;
}

Future<bool> _upload(context, String url, File image) async {
  try {
    UploadStatus uploadFile = UploadStatus();
    await uploadFile.call(url, image);

    if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
      return true;
    } else {
      throw uploadFile.message;
    }
  } catch (e) {
    throw e;
  }
}
