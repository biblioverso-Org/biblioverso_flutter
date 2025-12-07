import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/libro_service.dart';
import 'package:biblioverso_flutter/data/models/libro.dart';

class MockLibroService extends Mock implements LibroService {}

void main() {
  late MockLibroService service;

  setUp(() {
    service = MockLibroService();
  });

  test('getLibrosByCategoria retorna lista de libros', () async {
    when(() => service.getLibrosByCategoria(1)).thenAnswer((_) async => [
      Libro(idLibro: 1, titulo: 'Libro Test', disponibles: 5),
    ]);
    final result = await service.getLibrosByCategoria(1);
    expect(result, isA<List<Libro>>());
  });

  test('getLibroDetalle retorna un libro', () async {
    when(() => service.getLibroDetalle(1))
        .thenAnswer((_) async => Libro(idLibro: 1, titulo: 'Detalle', disponibles: 3));
    final result = await service.getLibroDetalle(1);
    expect(result.titulo, 'Detalle');
  });

  test('addOpinion y addReserva llaman al servicio', () async {
    when(() => service.addOpinion(1, 1, 5, 'Comentario'))
        .thenAnswer((_) async {});
    when(() => service.addReserva(1, 1, 1)).thenAnswer((_) async {});

    await service.addOpinion(1, 1, 5, 'Comentario');
    await service.addReserva(1, 1, 1);

    verify(() => service.addOpinion(1, 1, 5, 'Comentario')).called(1);
    verify(() => service.addReserva(1, 1, 1)).called(1);
  });
}
