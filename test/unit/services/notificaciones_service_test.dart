import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/notificaciones_service.dart';

class MockNotificacionesService extends Mock implements NotificacionesService {}

void main() {
  late MockNotificacionesService service;

  setUp(() {
    service = MockNotificacionesService();
  });

  test('getNotificaciones retorna lista de notificaciones', () async {
    when(() => service.getNotificaciones(1)).thenAnswer((_) async => [
      {'id': 1, 'mensaje': 'Nueva notificación', 'leida': false}
    ]);
    final result = await service.getNotificaciones(1);
    expect(result, isA<List<Map<String, dynamic>>>());
    expect(result.first['mensaje'], 'Nueva notificación');
  });

  test('marcarLeida llama correctamente al servicio', () async {
    when(() => service.marcarLeida(1)).thenAnswer((_) async {});
    await service.marcarLeida(1);
    verify(() => service.marcarLeida(1)).called(1);
  });

  test('marcarTodasLeidas llama correctamente al servicio', () async {
    when(() => service.marcarTodasLeidas(1)).thenAnswer((_) async {});
    await service.marcarTodasLeidas(1);
    verify(() => service.marcarTodasLeidas(1)).called(1);
  });
}
