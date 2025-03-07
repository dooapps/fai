import 'dart:convert';
import 'package:crypto/crypto.dart';



int generateNumericSymbol(String ticker) {
  var bytes = utf8.encode(ticker);
  var hash = sha256.convert(bytes).toString();
  return int.parse(hash.substring(0, 10), radix: 16) % 1000000000;
}

