import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/BimaToInggris_model.dart';

class TranslationService {
  final String baseUrl;

  TranslationService({required this.baseUrl});

  Future<TranslationModel> getTranslation(String word) async {
    final response = await http.get(Uri.parse('$baseUrl/kamus/inggris-bima/$word'));

    if (response.statusCode == 200) {
      return TranslationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load translation');
    }
  }
}
