import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kamus_new/model/apicloud_model.dart';

class ApiCloudServiceReverse {
  final url = 'http://karongga.my.id/api/reverse';

  Future<ApiCloudModel?> getApiCloudReverse(String word) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "word": word,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return ApiCloudModel.fromJson(responseBody);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
