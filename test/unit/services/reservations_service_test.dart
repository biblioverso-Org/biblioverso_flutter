import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/data/services/reservations_service.dart';

class MockReservationsService extends Mock implements ReservationsService {}

void main() {
  late MockReservationsService service;

  setUp(() {
    service = MockReservationsService();
  });

  test('getReservas retorna lista de reservas', () async {
    when(() => service.getReservas(1)).thenAnswer((_) async => [
      {'id': 1, 'estado': 'pendiente', 'libro': 'Libro A'}
    ]);
    final result = await service.getReservas(1);
    expect(result, isA<List<Map<String, dynamic>>>());
  });

  test('cancelarReserva llama correctamente', () async {
    when(() => service.cancelarReserva(1)).thenAnswer((_) async {});
    await service.cancelarReserva(1);
    verify(() => service.cancelarReserva(1)).called(1);
  });

  test('reservarLibro llama correctamente', () async {
    when(() => service.reservarLibro(1, 1, 1)).thenAnswer((_) async {});
    await service.reservarLibro(1, 1, 1);
    verify(() => service.reservarLibro(1, 1, 1)).called(1);
  });

  test('unirseListaEspera llama correctamente', () async {
    when(() => service.unirseListaEspera(1, 1)).thenAnswer((_) async {});
    await service.unirseListaEspera(1, 1);
    verify(() => service.unirseListaEspera(1, 1)).called(1);
  });
}
