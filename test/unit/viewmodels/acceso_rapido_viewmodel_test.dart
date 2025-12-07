  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';
  import 'package:biblioverso_flutter/viewmodel/acceso_rapido_viewmodel.dart';
  import 'package:biblioverso_flutter/data/services/acceso_rapido_service.dart';

  class MockAccesoRapidoService extends Mock implements AccesoRapidoService {}

  void main() {
    late AccesoRapidoViewModel viewModel;
    late MockAccesoRapidoService mockService;

    setUp(() {
      mockService = MockAccesoRapidoService();
      viewModel = AccesoRapidoViewModel(service: mockService);
    });

    test('estado inicial', () {
      expect(viewModel.reservasActivas, 0);
      expect(viewModel.favoritos, 0);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('fetchAccesos carga reservas y favoritos correctamente', () async {
      when(() => mockService.getReservasActivas(1)).thenAnswer((_) async => 3);
      when(() => mockService.getFavoritos(1)).thenAnswer((_) async => 5);

      final future = viewModel.fetchAccesos(1);

      // isLoading debe ser true mientras se ejecuta
      expect(viewModel.isLoading, true);

      await future;

      expect(viewModel.reservasActivas, 3);
      expect(viewModel.favoritos, 5);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);

      verify(() => mockService.getReservasActivas(1)).called(1);
      verify(() => mockService.getFavoritos(1)).called(1);
    });

    test('fetchAccesos maneja errores correctamente', () async {
      when(() => mockService.getReservasActivas(1))
          .thenThrow(Exception('Error reservas'));
      when(() => mockService.getFavoritos(1)).thenAnswer((_) async => 0);

      await viewModel.fetchAccesos(1);

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNotNull);
    });
  }
