import 'dart:convert';
import 'package:http/http.dart';
import 'package:kamus_new/model/translation_model.dart';

class TranslationService {
  final url = 'https://api-kamus.jaksparohserver.my.id/kamus/translate' ;

  Future<TranslationModel?> getTranslation(String word) async {
    final response = await post(
      Uri.parse(url),body: {
        "word" : word,
        "source_language" : "bima",
        "target_language" : "indonesia"
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody['data']);
      return TranslationModel.fromJson(responseBody);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
