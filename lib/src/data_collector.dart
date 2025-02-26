import 'dart:convert';
import 'package:http/http.dart' as http;
import '_internal_utils.dart';

class DataCollector {
  static Future<Map<String, dynamic>> fetchStockData(String publicKey, String urlCollector, Map<String, dynamic> params, Map<String, String> headers) async {
    final queryString = buildQueryParams(params);

    final url = "$urlCollector$queryString";

    final response = await http.get(
      Uri.parse(url),
      headers: headers, 
    );

    if (response.statusCode == 200) {
      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    } else {
      throw Exception('Error message: ${response.statusCode}, ${response.body}');
    }
  }

  
}
