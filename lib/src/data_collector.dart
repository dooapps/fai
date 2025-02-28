import 'dart:convert';
import 'package:finbo_fai/src/data_mapper.dart';
import 'package:http/http.dart' as http;
import '_internal_utils.dart';

class DataCollector {
  static Future<Map<String, dynamic>> fetchStockData(
      String publicKey,
      String urlCollector,
      Map<String, dynamic> params,
      Map<String, String> headers,
      Map<String, String> fieldMappings) async {

    final queryString = buildQueryParams(params);

    final url = "$urlCollector$queryString";

    final response = await http.get(
      Uri.parse(url),
      headers: headers, 
    );
    
    DataMapper mapper = DataMapper(fieldMappings);

    if (response.statusCode == 200) {
      final rawData = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": mapper.processRawData(rawData["data"]),
      };
    } else {
      throw Exception('Error message: ${response.statusCode}, ${response.body}');
    }
  }

  
}
