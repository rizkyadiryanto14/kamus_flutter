import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kamus_new/model/apicloud_model.dart';

class ApiCloudService {
  final String url = 'http://karongga.my.id/api/cloud';

  Future<ApiCloudModel?> getApiCloud(
      String word, String sourceLang, String targetLang) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "word": word,
          "source_language": sourceLang,
          "target_language": targetLang
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return ApiCloudModel.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
