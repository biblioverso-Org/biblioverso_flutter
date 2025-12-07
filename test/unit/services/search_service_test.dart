import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/search_service.dart';

class MockSearchService extends Mock implements SearchService {}

void main() {
  late MockSearchService service;

  setUp(() {
    service = MockSearchService();
  });

  test('getBooks retorna lista de libros filtrados', () async {
    when(() => service.getBooks(query: 'Libro', filter: 'Todos'))
        .thenAnswer((_) async => [
      {'id': 1, 'titulo': 'Libro Test'}
    ]);
    final result = await service.getBooks(query: 'Libro', filter: 'Todos');
    expect(result, isA<List<Map<String, dynamic>>>());
    expect(result.first['titulo'], 'Libro Test');
  });

  test('getCategories retorna lista de categorías', () async {
    when(() => service.getCategories()).thenAnswer((_) async => ['Todos', 'Ficción']);
    final result = await service.getCategories();
    expect(result, isA<List<String>>());
    expect(result.length, 2);
  });
}
