import 'dart:convert';

import 'package:http/http.dart';
import 'package:kamus_new/model/saran_kata_model.dart';

class SaraKataService{
  final url = 'https://api-kamus.jaksparohserver.my.id/saran_kata';

  Future<SaranKataModel?> getSaranKata(String source_lang, String target_lang, String lang) async{
   final response = await post(
      Uri.parse(url),body: {
        "bahasa_asal"   : source_lang,
        "bahasa_tujuan" : target_lang,
        "kata_asal"     : lang
      }
    );

   if(response.statusCode == 200) {
     final Map<String, dynamic> responseBody = jsonDecode(response.body);
     return SaranKataModel.fromJson(responseBody);
   }else {
     print('Error: ${response.statusCode}');
     return null;
   }

  }
}