import 'package:fai/bridge_generated.dart/api.dart';

Future<int> getBlindScale(String assetType) async {
  final result = await FbblApi.fbblGenerateNumericHash(input: assetType);
  return result.toInt();
}

Future<int> encodeScale(double value, String assetType) async {
  final hash = await getBlindScale(assetType);
  return (value * hash).round();
}

Future<double> decodeScale(int value, String assetType) async {
  final hash = await getBlindScale(assetType);
  return value / hash;
}

Future<double> generateBlindScale(String assetType) async {
  final hash = await getBlindScale(assetType);
  return hash.toDouble();
}

Future<List<double>> applyBlindScale(
    List<int> encodedValues, double blindScale) async {
  return encodedValues.map((e) => e / blindScale).toList();
}

Future<List<int>> revertBlindScale(
    List<double> blindValues, double blindScale) async {
  return blindValues.map((e) => (e * blindScale).round()).toList();
}
