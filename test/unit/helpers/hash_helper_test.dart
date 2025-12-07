import 'package:flutter_test/flutter_test.dart';
import 'package:biblioverso_flutter/core/utils/hash_helper.dart';

void main() {
  group("HashHelper - SHA256", () {
    test("Debe generar un hash válido", () {
      final hash = HashHelper.hashPassword("123456");

      expect(hash.length, 64); // longitud exacta de SHA256
      expect(hash, isA<String>());
      expect(hash, isNot("123456"));
    });

    test("El mismo texto debe generar el mismo hash", () {
      final h1 = HashHelper.hashPassword("abc123");
      final h2 = HashHelper.hashPassword("abc123");

      expect(h1, h2);
    });

    test("Hashes diferentes no deben coincidir", () {
      final h1 = HashHelper.hashPassword("password");
      final h2 = HashHelper.hashPassword("otroPassword");

      expect(h1 == h2, false);
    });
  });
}
