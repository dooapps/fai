import 'dart:convert';


import 'package:test/test.dart';


import 'package:fai/src/data_collector.dart';
import 'package:fai/src/data_formater.dart';


void main() {


  group('DataFormater.formatYahooData - Teste com API real', () {
    test('Deve formatar dados válidos do Yahoo Finance', () async {
      final String urlCollector = "https://yahoo-finance-api-data.p.rapidapi.com/chart/simple-chart";

      final params = {
        "symbol": "PETR3.SA",
        "limit": "10",
        "range": "1d",
      };

      final headers = {
        "x-rapidapi-host": "yahoo-finance-api-data.p.rapidapi.com",
        "x-rapidapi-key": "<SUA_API_KEY_AQUI>", // 🔥 Atenção: Substitua pela sua chave válida
      };

      final fieldMappings = {
        "meta": "meta",
        "timestamp": "timestamp",
        "indicators": "indicators",
      };

      final response = await DataCollector.fetchStockData(
        "public_key",
        urlCollector,
        params,
        headers,
        fieldMappings,
      );

      expect(response["success"], true, reason: "API request failed: ${response['error']}");
      expect(response["statusCode"], equals(200));

      final formatted = DataFormater.formatYahooData(
        response["body"],
        "PETR3.SA",
        fieldMappings,
      );

      print("Asset ID: ${formatted['asset_id']}");
      print("Formatted Data: ${jsonEncode(formatted['data'])}");

      expect(formatted['asset_id'], isNotNull);
      expect(formatted['data']['meta'], isNotEmpty);

      final indicators = formatted['data']['indicators'] as Map<String, dynamic>;
      expect(formatted['data']['timestamp'], isNotEmpty);
      expect(indicators['close'], isNotEmpty);
    });
  });
}