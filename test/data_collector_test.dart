import 'dart:convert';
import 'package:test/test.dart';
import 'package:finbo_fai/src/data_collector.dart';


void main() {
  group('DataCollector.fetchStockData Yahoo API - Teste com API real', () {
    test('Deve retornar dados válidos da API real', () async {
      final String urlCollector = "https://yahoo-finance-api-data.p.rapidapi.com/chart/simple-chart";

      final Map<String, dynamic> params = {
        "symbol": "PETR3.SA",
        "limit": "10",
        "range": "1d"
      };

      final Map<String, String> headers = {
        "x-rapidapi-host": "yahoo-finance-api-data.p.rapidapi.com",
        "x-rapidapi-key": "e0e6d6264dmsh2f3884c1cd7b529p1a29efjsnb7cdc6ac30ce",
      };

      Map<String, String> fieldMappings = {
            "meta":"meta",
            "timestamp":"timestamp",
            "indicators":"indicators"
          };

      try {
        final response = await DataCollector.fetchStockData(
          "public_key",
          urlCollector,
          params,
          headers,
          fieldMappings,
        );

        print("Resposta da API: ${jsonEncode(response)}");

        expect(response["statusCode"], equals(200));
      } catch (e) {
        print("Error message: $e");
        fail("Error from API: $e");
      }
    });
  });
  group('DataCollector.fetchStockData Wallet Finbo API - Teste com API real', () {
    test('Deve retornar dados válidos da API real', () async {
      final String urlCollector = "https://itva-crypto-ia-2405334676d1.herokuapp.com/v1/wallet/66cf9db3a7940580210770f7";

      final Map<String, dynamic> params = {};

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-api-key": "6b77b8ee-9790-427a-a27f-601b0cde0d53",
      };

      Map<String, String> fieldMappings = {
            "id": "id",
            "name": "name",
            "startDate": "startDate",
            "baseInvestment": "baseInvestment",
            "balance": "balance",
            "lastBtcPrice": "lastBtcPrice"
          };

      try {
        final response = await DataCollector.fetchStockData(
          "public_key",
          urlCollector,
          params,
          headers,
          fieldMappings,
        );

        print("Resposta da API: ${jsonEncode(response)}");

        expect(response["statusCode"], equals(200));
      } catch (e) {
        print("Error message: $e");
        fail("Error from API: $e");
      }
    });
  }
  
  

  );
}
