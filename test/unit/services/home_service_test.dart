import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/home_service.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  late MockHomeService service;

  setUp(() {
    service = MockHomeService();
  });

  test('getNovedades retorna lista', () async {
    when(() => service.getNovedades())
        .thenAnswer((_) async => [{'id': 1, 'titulo': 'Libro A'}]);
    final result = await service.getNovedades();
    expect(result, isA<List<Map<String, dynamic>>>());
  });

  test('getDestacados retorna lista', () async {
    when(() => service.getDestacados())
        .thenAnswer((_) async => [{'id': 2, 'titulo': 'Libro B'}]);
    final result = await service.getDestacados();
    expect(result, isA<List<Map<String, dynamic>>>());
  });
}
