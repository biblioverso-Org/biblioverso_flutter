import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/reservations_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/reservations_service.dart';

class MockReservationsService extends Mock implements ReservationsService {}

void main() {
  late ReservationsViewModel viewModel;
  late MockReservationsService mockService;

  setUp(() {
    mockService = MockReservationsService();
    viewModel = ReservationsViewModel(service: mockService); // inyectamos mock
  });

  group('ReservationsViewModel', () {
    test('estado inicial', () {
      expect(viewModel.activeReservations, isEmpty);
      expect(viewModel.historyReservations, isEmpty);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.tabIndex, 0);
    });

    test('setTab cambia correctamente', () {
      viewModel.setTab(1);
      expect(viewModel.tabIndex, 1);
    });

    test('fetchReservas filtra correctamente reservas', () async {
      final reservasMock = [
        {"id": 1, "estado": "Pendiente"},
        {"id": 2, "estado": "Completada"},
        {"id": 3, "estado": "Recoger"},
        {"id": 4, "estado": "Cancelado"},
      ];

      when(() => mockService.getReservas(any()))
          .thenAnswer((_) async => reservasMock);

      await viewModel.fetchReservas(1);

      expect(viewModel.activeReservations.length, 2);
      expect(viewModel.historyReservations.length, 2);
      verify(() => mockService.getReservas(1)).called(1);
    });

    test('fetchReservas maneja errores', () async {
      when(() => mockService.getReservas(any()))
          .thenThrow(Exception('Error de red'));

      await viewModel.fetchReservas(1);

      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('cancelReserva llama al servicio', () async {
      when(() => mockService.cancelarReserva(any()))
          .thenAnswer((_) async {});

      await viewModel.cancelReserva(1);

      verify(() => mockService.cancelarReserva(1)).called(1);
    });

    test('reservarLibro llama al servicio y refresca reservas', () async {
      when(() => mockService.reservarLibro(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => mockService.getReservas(any()))
          .thenAnswer((_) async => []);

      await viewModel.reservarLibro(1, 2, 1);

      verify(() => mockService.reservarLibro(1, 2, 1)).called(1);
      verify(() => mockService.getReservas(1)).called(1);
    });

    test('unirseListaEspera llama al servicio y refresca reservas', () async {
      when(() => mockService.unirseListaEspera(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockService.getReservas(any()))
          .thenAnswer((_) async => []);

      await viewModel.unirseListaEspera(1, 2);

      verify(() => mockService.unirseListaEspera(1, 2)).called(1);
      verify(() => mockService.getReservas(1)).called(1);
    });
  });
}
