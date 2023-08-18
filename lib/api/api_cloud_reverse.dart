import 'dart:convert';
import 'package:http/http.dart';
import 'package:kamus_new/model/apicloud_model.dart';

class ApiCloudServiceReverse {
  final url = 'https://api-kamus.jaksparohserver.my.id/api/reverse';

  Future<ApiCloudModel?> getApiCloudReverse(String word) async {
    final response = await post(
        Uri.parse(url), body: {
      "word" : word
      }
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      //print(responseBody['data']['translatedText']);
      return ApiCloudModel.fromJson(responseBody);
    }else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}