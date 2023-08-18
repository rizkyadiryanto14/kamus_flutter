import 'dart:convert';
import 'package:http/http.dart';
import 'package:kamus_new/model/apicloud_model.dart';

class ApiCloudService {
  final url = 'https://api-kamus.jaksparohserver.my.id/api/cloud';

  Future<ApiCloudModel?> getApiCloud(String word) async {
    final response = await post(
        Uri.parse(url), body: {
          "word" : word
      }
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      return ApiCloudModel.fromJson(responseBody);
    }else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}