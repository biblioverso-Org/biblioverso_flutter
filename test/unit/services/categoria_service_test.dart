import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/categoria_service.dart';
import 'package:biblioverso_flutter/data/models/categoria.dart';

class MockCategoriaService extends Mock implements CategoriaService {}

void main() {
  late MockCategoriaService service;

  setUp(() {
    service = MockCategoriaService();
  });

  test('getAllCategoriasConConteo retorna lista de categorías', () async {
    when(() => service.getAllCategoriasConConteo()).thenAnswer(
          (_) async => [
        Categoria(idCategoria: 1, nombre: 'Ficción', cantidadLibros: 5)
      ],
    );

    final result = await service.getAllCategoriasConConteo();

    expect(result, isA<List<Categoria>>());
    expect(result.length, 1);
    expect(result[0].nombre, 'Ficción');
    expect(result[0].cantidadLibros, 5);

    verify(() => service.getAllCategoriasConConteo()).called(1);
  });
}
