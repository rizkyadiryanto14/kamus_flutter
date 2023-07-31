import 'dart:convert';
import 'package:http/http.dart';
import '../model/translation_model.dart';

class TranslationService {
  final url = 'https://api-kamus.jaksparohserver.my.id/kamus/translate' ;
  Future<TranslationModel?> getTranslation(String word) async {

    final response = await post(
      Uri.parse(url),body: {
        "word" : word,
        "source_language" : "indonesia",
        "target_language" : "inggris"
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      return TranslationModel.fromJson(responseBody);
    } else {
      //Penanganan error
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
