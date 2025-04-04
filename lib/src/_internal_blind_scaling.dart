import 'dart:math';


int getBlindScale(String assetType) {
  switch (assetType) {
    case 'crypto':
      return pow(10, 7).toInt(); // 10^7
    case 'stocks':
      return 100; 
    default:
      return 1;
  }
}

int encodeScale(double value, String assetType) {
  return (value * getBlindScale(assetType)).round();
}

double decodeScale(int value, String assetType) {
  return value / getBlindScale(assetType);
}


double generateBlindScale(String assetType) {
  final rand = Random();
  if (assetType == 'crypto') {
    return pow(10, rand.nextInt(7) + 3).toDouble(); // 10^3 a 10^9
  } else if (assetType == 'stocks') {
    return rand.nextDouble() * 4.5 + 0.5; // 0.5 a 5.0
  } else {
    return 1.0;
  }
}

List<double> applyBlindScale(List<int> encodedValues, double blindScale) {
  return encodedValues.map((v) => v * blindScale).toList();
}

List<int> revertBlindScale(List<double> blindValues, double blindScale) {
  return blindValues.map((v) => (v / blindScale).round()).toList();
}