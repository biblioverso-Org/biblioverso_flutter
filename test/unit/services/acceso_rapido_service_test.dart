import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/acceso_rapido_service.dart';

class MockAccesoRapidoService extends Mock implements AccesoRapidoService {}

void main() {
  late MockAccesoRapidoService service;

  setUp(() {
    service = MockAccesoRapidoService();
  });

  test('getReservasActivas retorna valor correcto', () async {
    when(() => service.getReservasActivas(1)).thenAnswer((_) async => 3);
    final result = await service.getReservasActivas(1);
    expect(result, 3);
    verify(() => service.getReservasActivas(1)).called(1);
  });

  test('getFavoritos retorna valor correcto', () async {
    when(() => service.getFavoritos(1)).thenAnswer((_) async => 5);
    final result = await service.getFavoritos(1);
    expect(result, 5);
    verify(() => service.getFavoritos(1)).called(1);
  });
}
