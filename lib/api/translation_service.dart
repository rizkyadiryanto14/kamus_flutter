import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/translation_model.dart';

class TranslationService {
  final String baseUrl;

  TranslationService({required this.baseUrl});

  Future<TranslationModel> getTranslation(
      String word, {
        String sourceLanguage = 'indonesia',
        String targetLanguage = 'inggris',
      }) async {
    print('ini adalah inputan: $word');
    print('ini adalah bahasa sumber: $sourceLanguage');
    print('ini adalah bahasa target: $targetLanguage');

    final response = await http.post(
      Uri.parse('$baseUrl/kamus/translate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'word': word,
        'inggris': sourceLanguage,
        'target_language': targetLanguage,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    final responseData = json.decode(response.body);
    print('Response Body: ${responseData['data']}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Tambahkan pernyataan print untuk melihat respons JSON
      print(jsonResponse);

      // Jika respon JSON berisi langsung hasil terjemahan, gunakan nilai tersebut
      if (jsonResponse is String) {
        return TranslationModel(
          word: jsonResponse,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        );
      } else if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse.containsKey('data')) {
          return TranslationModel(
            word: jsonResponse['data'],
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
          );
        }
      }
    }
    throw Exception('Failed to load translation');
  }
}





