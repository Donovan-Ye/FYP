import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenerateImageUrl {
  bool success;
  String message;

  bool isGenerated;

  String uploadUrl;
  String downloadUrl;

  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": fileType};

      var response = await http.post(
        env['API_SERVER'] + "/generatePresignedUrl",
        body: body,
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
      throw ('Error getting url');
    }
  }
}
