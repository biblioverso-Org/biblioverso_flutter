import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/favorites_service.dart';

class MockFavoritesService extends Mock implements FavoritesService {}

void main() {
  late MockFavoritesService service;

  setUp(() {
    service = MockFavoritesService();
  });

  test('getFavorites retorna lista', () async {
    when(() => service.getFavorites(1))
        .thenAnswer((_) async => [{'id': 1, 'titulo': 'Libro A'}]);
    final result = await service.getFavorites(1);
    expect(result, isA<List<Map<String, dynamic>>>());
    expect(result.first['titulo'], 'Libro A');
  });

  test('addFavorito y removeFavorito se llaman correctamente', () async {
    when(() => service.addFavorito(1, 1)).thenAnswer((_) async {});
    when(() => service.removeFavorito(1, 1)).thenAnswer((_) async {});

    await service.addFavorito(1, 1);
    await service.removeFavorito(1, 1);

    verify(() => service.addFavorito(1, 1)).called(1);
    verify(() => service.removeFavorito(1, 1)).called(1);
  });
}
