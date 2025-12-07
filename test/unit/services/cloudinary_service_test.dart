import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/core/utils/cloudinary_service.dart';
import 'dart:io';

class MockClient extends Mock implements http.Client {}

void main() {
  group("CloudinaryService", () {
    test("Debe lanzar excepción si el upload falla", () async {
      final file = File("fake.png");

      expect(
            () async => CloudinaryService.uploadImage(file),
        throwsA(isA<Exception>()),
      );
    });
  });
}
