import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/opinion_service.dart';

class MockOpinionService extends Mock implements OpinionService {}

void main() {
  late MockOpinionService service;

  setUp(() {
    service = MockOpinionService();
  });

  test('getOpiniones retorna lista de opiniones', () async {
    when(() => service.getOpiniones(1)).thenAnswer((_) async => [
      {'id': 1, 'usuario': 'Miguel', 'comentario': 'Muy bueno', 'calificacion': 5}
    ]);

    final result = await service.getOpiniones(1);
    expect(result, isA<List<Map<String, dynamic>>>());
    expect(result.first['usuario'], 'Miguel');
  });

  test('agregarOpinion llama al servicio correctamente', () async {
    when(() => service.agregarOpinion(1, 1, 5, 'Excelente')).thenAnswer((_) async {});
    await service.agregarOpinion(1, 1, 5, 'Excelente');
    verify(() => service.agregarOpinion(1, 1, 5, 'Excelente')).called(1);
  });
}
