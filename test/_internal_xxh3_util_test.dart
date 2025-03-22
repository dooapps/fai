import 'package:test/test.dart';
import 'package:finbo_fai/src/_internal_xxh3_util.dart';

void main() {
  group('generateXxh3Hash Tests', () {
    // Teste 1: Verifica se o hash é consistente para a mesma entrada
    test('should generate consistent hash for the same input', () {
      final hash1 = generateXxh3Hash('PETR4');
      final hash2 = generateXxh3Hash('PETR4');
      expect(hash1, equals(hash2));
    });

    // Teste 2: Verifica se o hash é diferente para entradas diferentes
    test('should generate different hashes for different inputs', () {
      final hashPetr4 = generateXxh3Hash('PETR4');
      final hashVale3 = generateXxh3Hash('VALE3');
      expect(hashPetr4, isNot(equals(hashVale3)));
    });

    // Teste 3: Verifica se o trim e uppercase funcionam corretamente
    test('should sanitize input by trimming and converting to uppercase', () {
      final hash1 = generateXxh3Hash('petr4 ');
      final hash2 = generateXxh3Hash('PETR4');
      expect(hash1, equals(hash2));
    });

    // Teste 4: Verifica se entradas vazias ou apenas espaços geram hash consistente
    test('should handle empty or whitespace-only input', () {
      final hashEmpty = generateXxh3Hash('');
      final hashWhitespace = generateXxh3Hash('   ');
      expect(hashEmpty, equals(hashWhitespace));
    });

    // Teste 5: Verifica se hashes são gerados para prefixos diferentes
    test('should generate unique hashes for ticker prefixes', () {
      final hashP = generateXxh3Hash('P');
      final hashPe = generateXxh3Hash('PE');
      final hashPet = generateXxh3Hash('PET');
      expect(hashP, isNot(equals(hashPe)));
      expect(hashPe, isNot(equals(hashPet)));
    });

    // Teste 6: Verifica se o hash está dentro do intervalo de 64 bits
    test('should generate a 64-bit integer', () {
      final hash = generateXxh3Hash('PETR4');
      expect(hash, greaterThanOrEqualTo(-(1 << 63))); // Min int64
      expect(hash, lessThanOrEqualTo((1 << 63) - 1)); // Max int64
    });
  });
}