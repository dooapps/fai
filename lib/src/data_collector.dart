import 'dart:convert';
import 'package:dio/dio.dart';
import '_internal_utils.dart';

class DataCollector {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ))
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

  static Future<Map<String, dynamic>> fetchStockData(
    String publicKey,
    String urlCollector,
    Map<String, dynamic> params,
    Map<String, String> headers,
    Map<String, String> fieldMappings,
  ) async {
    final queryString = buildQueryParams(params);
    final url = "$urlCollector$queryString";

    print("Fetching data from: $url"); // Debugging

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain, // Evita problemas com gzip
        ),
      );

      return {
        "statusCode": response.statusCode,
        "body": _parseResponse(response),
        "success": response.statusCode! >= 200 && response.statusCode! < 300,
      };

    } on DioException catch (e) {
      // Erros HTTP (404, 500, etc.)
      return {
        "statusCode": e.response?.statusCode ?? 500,
        "error": e.message,
        "success": false,
      };
    } catch (e) {
      // Erros inesperados
      return {
        "statusCode": 500,
        "error": e.toString(),
        "success": false,
      };
    }
  }

  static dynamic _parseResponse(Response response) {
    try {
      if (response.data is String) {
        return jsonDecode(response.data);
      }
      return response.data;
    } catch (_) {
      return {"error": "Invalid JSON response"};
    }
  }
}