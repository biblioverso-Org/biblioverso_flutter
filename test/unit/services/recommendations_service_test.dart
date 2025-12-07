import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/recommendations_service.dart';

class MockRecommendationsService extends Mock implements RecommendationsService {}

void main() {
  late MockRecommendationsService service;

  setUp(() {
    service = MockRecommendationsService();
  });

  test('getForYou retorna lista de libros', () async {
    when(() => service.getForYou(1)).thenAnswer((_) async => [
      {'id': 1, 'titulo': 'Libro A'}
    ]);
    final result = await service.getForYou(1);
    expect(result, isA<List<Map<String, dynamic>>>());
  });

  test('getPopular retorna lista de libros', () async {
    when(() => service.getPopular()).thenAnswer((_) async => [
      {'id': 2, 'titulo': 'Libro B'}
    ]);
    final result = await service.getPopular();
    expect(result, isA<List<Map<String, dynamic>>>());
  });

  test('getRecent retorna lista de libros', () async {
    when(() => service.getRecent()).thenAnswer((_) async => [
      {'id': 3, 'titulo': 'Libro C'}
    ]);
    final result = await service.getRecent();
    expect(result, isA<List<Map<String, dynamic>>>());
  });
}
