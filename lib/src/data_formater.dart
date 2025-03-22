import 'package:finbo_fai/src/_internal_xxh3_util.dart';

class DataFormater {
  static Map<String, dynamic> formatYahooData(
    Map<String, dynamic> rawData,
    String ticker,
    Map<String, String> fieldMappings,
  ) {
    // Converte ticker para hash numérico
    int assetId = generateXxh3Hash(ticker);

    // Extrai e mapeia os dados
    Map<String, dynamic> formattedData = _mapYahooData(rawData, fieldMappings);

    return {
      "asset_id": assetId,
      "data": formattedData,
    };
  }



  // Mapeia os dados do Yahoo Finance
  static Map<String, dynamic> _mapYahooData(
    Map<String, dynamic> rawData,
    Map<String, String> fieldMappings,
  ) {
    if (!rawData.containsKey('data') || rawData['data'].isEmpty) {
      return {"error": "No data found in response"};
    }

    var data = rawData['data'][0];
    return {
      "meta": data[fieldMappings['meta']] ?? {},
      "timestamps": data[fieldMappings['timestamp']] ?? [],
      "indicators": _mapIndicators(data[fieldMappings['indicators']] ?? {}),
    };
  }

  // Mapeia os indicadores (OHLCV)
  static Map<String, List<dynamic>> _mapIndicators(Map<String, dynamic> indicators) {
    if (!indicators.containsKey('quote') || indicators['quote'].isEmpty) {
      return {"error": []};
    }

    var quote = indicators['quote'][0];
    return {
      "open": quote['open'] ?? [],
      "high": quote['high'] ?? [],
      "low": quote['low'] ?? [],
      "close": quote['close'] ?? [],
      "volume": quote['volume'] ?? [],
    };
  }
}