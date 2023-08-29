import 'dart:convert';
import 'package:http/http.dart';
import 'package:kamus_new/model/saran_kata_model.dart';

class SaraKataService{
  final url = 'https://api-kamus.jaksparohserver.my.id/saran_kata';

  Future<SaranKataModel?> getSaranKata(String source_lang, String target_lang, String lang) async{
    try {
      final response = await post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer <insert access token here>'},
        body: {
          "bahasa_asal": source_lang.trim(),
          "bahasa_tujuan": target_lang.trim(),
          "kata_asal": lang.trim()
        }
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if(responseBody.containsKey('data')) {
          return SaranKataModel.fromJson(responseBody['data']);
        }
      }

      print('Error: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}