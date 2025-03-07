FinBo_AI Data Collector

FinBo_AI Data Collector is a high-performance financial data collection and mapping system designed to integrate and structure information from market APIs like Yahoo Finance and TradingView. It enables capturing, processing, and transforming financial data into actionable insights for investors, traders, and analysts.

Features
	•	📊 Real-time Financial Data Collection from multiple market sources.
	•	🚀 Automatic Field Mapping to ensure compatibility across different APIs.
	•	🔄 Data Conversion for standardized formats, including numbers and lists.
	•	🔍 Detailed Logging for debugging and monitoring API requests.

 import 'package:finbo_ai_data_collector/data_collector.dart';

void main() async {
  final String url = "https://yahoo-finance-api-data.p.rapidapi.com/chart/simple-chart";
  final Map<String, dynamic> params = {
    "symbol": "AAPL",
    "limit": "10",
    "range": "1d"
  };

  final Map<String, String> headers = {
    "x-rapidapi-host": "yahoo-finance-api-data.p.rapidapi.com",
    "x-rapidapi-key": "YOUR_API_KEY"
  };

  final Map<String, String> fieldMappings = {
    "meta": "meta",
    "timestamp": "timestamp",
    "indicators": "indicators"
  };

  final response = await DataCollector.fetchStockData(
    "public_key",
    url,
    params,
    headers,
    fieldMappings,
  );

  print(response);
}   

import 'package:finbo_ai_data_collector/data_mapper.dart';

void main() {
  final fieldMappings = {
    "price": "close",
    "volume": "volume",
    "date": "timestamp"
  };

  final rawData = [
    {"close": "145.32", "volume": "230000", "timestamp": "1702035200"},
    {"close": "146.01", "volume": "220000", "timestamp": "1702121600"},
  ];

  final mapper = DataMapper(fieldMappings);
  final processedData = mapper.processRawData(rawData);

  print(processedData);
}

dart test

Contributing

Want to contribute? Follow these steps:
	1.	Fork the repository.
	2.	Create a branch (git checkout -b my-new-feature).
	3.	Commit your changes (git commit -m 'Adding new feature').
	4.	Push the branch (git push origin my-new-feature).
	5.	Open a Pull Request.