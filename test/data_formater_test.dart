import 'dart:convert';
import 'package:test/test.dart';
import 'package:finbo_fai/src/data_collector.dart';
import 'package:finbo_fai/src/data_formater.dart';

void main() {
  group('DataFormater.formatYahooData - Teste com API real', () {
    test('Deve formatar dados válidos do Yahoo Finance', () async {
      final String urlCollector = "https://yahoo-finance-api-data.p.rapidapi.com/chart/simple-chart";

      final Map<String, dynamic> params = {
        "symbol": "PETR3.SA",
        "limit": "10",
        "range": "1d",
      };

      final Map<String, String> headers = {
        "x-rapidapi-host": "yahoo-finance-api-data.p.rapidapi.com",
        "x-rapidapi-key": "e0e6d6264dmsh2f3884c1cd7b529p1a29efjsnb7cdc6ac30ce",
      };

      final Map<String, String> fieldMappings = {
        "meta": "meta",
        "timestamp": "timestamp",
        "indicators": "indicators",
      };

      // Coleta os dados
      final response = await DataCollector.fetchStockData(
        "public_key",
        urlCollector,
        params,
        headers,
        fieldMappings,
      );

      // Verifica sucesso
      expect(response["success"], true, reason: "API request failed: ${response['error']}");
      expect(response["statusCode"], equals(200));

      // Formata os dados
      final formatted = DataFormater.formatYahooData(
        response["body"],
        "PETR3.SA",
        fieldMappings,
      );

      // Imprime para verificação
      print("Asset ID: ${formatted['asset_id']}");
      print("Formatted Data: ${jsonEncode(formatted['data'])}");

      // Testes básicos
      expect(formatted['asset_id'], isNotNull, reason: "Asset ID should be generated");
      expect(formatted['data']['meta'], isNotEmpty, reason: "Meta should contain data");

      final indicators = formatted['data']['indicators'] as Map<String, dynamic>;
      if (indicators['error'].isNotEmpty) {
        fail("Error in indicators: ${indicators['error']}");
      } else {
        expect(formatted['data']['timestamps'], isNotEmpty, reason: "Timestamps should contain data");
        expect(indicators['close'], isNotEmpty, reason: "Close prices should contain data");
        // Opcional: verificar tamanho exato se soubermos o esperado
        expect(formatted['data']['timestamps'].length, greaterThan(10), reason: "Timestamps should reflect full day data");
      }
    });
  });
}