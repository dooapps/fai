import '_internal_blind_scaling.dart';
import '_internal_crypto_util.dart';

List<num> generateCandleVector({
  required String assetType,
  required String ticker,
  required int timestamp,
  required double open,
  required double close,
  required double low,
  required double high,
}) {
  // 1. Codifica com escala adaptada
  final encodedOpen = encodeScale(open, assetType);
  final encodedClose = encodeScale(close, assetType);
  final encodedLow = encodeScale(low, assetType);
  final encodedHigh = encodeScale(high, assetType);

  // 2. Gera BlindScale e aplica
  final blindScale = generateBlindScale(assetType);
  final blindOHLC = applyBlindScale([
    encodedOpen, encodedClose, encodedLow, encodedHigh
  ], blindScale);

  // 3. Gera identificador seguro
  final fbblNumber = generateSecureNumericHash(ticker);

  // 4. Retorna vetor com timestamp aberto + dados ofuscados + identificador
  return [
    timestamp,
    ...blindOHLC,
    fbblNumber
  ];
}

List<List<num>> generateCandleVectors({
  required String assetType,
  required String ticker,
  required List<int> timestamps,
  required List<double> opens,
  required List<double> closes,
  required List<double> lows,
  required List<double> highs,
}) {

  final int length = timestamps.length;
  if ([opens, closes, lows, highs].any((list) => list.length != length)) {
    throw ArgumentError('Todas as listas devem ter o mesmo tamanho e não podem estar vazias.');
  }
  if (length == 0) {
    throw ArgumentError('As listas não podem estar vazias.');
  }

  final ffblNumber = generateSecureNumericHash(ticker);
  final blindScale = generateBlindScale(assetType);

  List<List<num>> vectors = [];

  for (int i = 0; i < length; i++) {
    final encodedOpen = encodeScale(opens[i], assetType);
    final encodedClose = encodeScale(closes[i], assetType);
    final encodedLow = encodeScale(lows[i], assetType);
    final encodedHigh = encodeScale(highs[i], assetType);

    final blindOHLC = applyBlindScale([
      encodedOpen, encodedClose, encodedLow, encodedHigh
    ], blindScale);

    vectors.add([
      timestamps[i],
      ...blindOHLC,
      ffblNumber
    ]);
  }

  return vectors;
}

List<Map<String, dynamic>> unpackCandleVectors({
  required List<List<num>> vectors,
  required String assetType,
  required double blindScale,
}) {
  final List<Map<String, dynamic>> unpacked = [];

  for (final vector in vectors) {
    if (vector.length != 6) continue; // segurança: formato esperado [timestamp, o, c, l, h, id]

    final timestamp = vector[0].toInt();
    final blindOHLC = vector.sublist(1, 5).cast<double>();
    final decodedOHLC = revertBlindScale(blindOHLC, blindScale)
        .map((v) => v / getBlindScale(assetType))
        .toList();

    unpacked.add({
      'timestamp': timestamp,
      'open': decodedOHLC[0],
      'close': decodedOHLC[1],
      'low': decodedOHLC[2],
      'high': decodedOHLC[3],
      'ffblNumber': vector[5].toInt(),
    });
  }

  return unpacked;
}