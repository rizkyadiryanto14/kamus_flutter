import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kamus_new/model/kamus_perkata_model.dart';

class ApiService {
  static Future<List<Translation>> fetchTranslations({String keyword = ''}) async {
    final response = await http.get(Uri.parse('http://karongga.my.id/admin/getJsonKamus?keyword=$keyword'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Translation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load translations');
    }
  }
}
