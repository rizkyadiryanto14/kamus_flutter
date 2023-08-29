import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kamus_new/model/translation_model.dart';

class TranslationServiceIndonesia {
  final url = 'https://api-kamus.jaksparohserver.my.id/kamus/translate';

  Future<TranslationModel?> getTranslationReverse(String word) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "word": word,
          "source_language": "indonesia",
          "target_language": "bima"
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);
        return TranslationModel.fromJson(responseBody);
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