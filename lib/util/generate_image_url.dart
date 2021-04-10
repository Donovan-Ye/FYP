import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenerateImageUrl {
  bool success;
  String message;

  bool isGenerated;

  String uploadUrl;
  String downloadUrl;

  Future<void> call(String fileType, String username,
      {String friendName,
      String friendPhone,
      bool isChangeProfile = false}) async {
    try {
      var response = await http.post(
        env['API_SERVER'] + "/generatePresignedUrl",
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "fileType": fileType,
          "username": username,
          "isChangeProfile": isChangeProfile,
          "friendInfo": {
            "name": friendName,
            "phone": friendPhone,
          }
        }),
      );

      var result = jsonDecode(response.body);

      print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["uploadUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
      throw ('Error getting url');
    }
  }
}
