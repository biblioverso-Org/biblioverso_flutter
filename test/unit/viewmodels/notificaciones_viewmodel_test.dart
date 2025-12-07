import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/notificaciones_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/notificaciones_service.dart';

class MockNotificacionesService extends Mock implements NotificacionesService {}

void main() {
  late MockNotificacionesService mockService;
  late NotificacionesViewModel viewModel;

  setUp(() {
    mockService = MockNotificacionesService();
    viewModel = NotificacionesViewModel();
    viewModel.setServiceForTest(mockService);
  });

  group("NotificacionesViewModel Tests", () {
    test("fetchNotificaciones() carga correctamente", () async {
      final fakeList = [
        {"id": 1, "mensaje": "Hola", "leida": false},
        {"id": 2, "mensaje": "Nueva alerta", "leida": false},
      ];

      when(() => mockService.getNotificaciones(10))
          .thenAnswer((_) async => fakeList);

      expect(viewModel.isLoading, false);

      final future = viewModel.fetchNotificaciones(10);

      expect(viewModel.isLoading, true);

      await future;

      expect(viewModel.notificaciones, fakeList);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isLoading, false);
    });

    test("fetchNotificaciones() maneja error", () async {
      when(() => mockService.getNotificaciones(10))
          .thenThrow(Exception("DB error"));

      await viewModel.fetchNotificaciones(10);

      expect(viewModel.errorMessage, contains("Error al cargar notificaciones"));
      expect(viewModel.notificaciones, isEmpty);
      expect(viewModel.isLoading, false);
    });

    test("marcarLeida() actualiza solo la notificación indicada", () async {
      viewModel.notificaciones = [
        {"id": 1, "mensaje": "Hola", "leida": false},
        {"id": 2, "mensaje": "Nuevo mensaje", "leida": false},
      ];

      when(() => mockService.marcarLeida(1))
          .thenAnswer((_) async => Future.value());

      await viewModel.marcarLeida(1);

      expect(viewModel.notificaciones[0]["leida"], true);
      expect(viewModel.notificaciones[1]["leida"], false);
    });

    test("marcarTodas() marca todas como leídas", () async {
      viewModel.notificaciones = [
        {"id": 1, "mensaje": "Hola", "leida": false},
        {"id": 2, "mensaje": "Nuevo mensaje", "leida": false},
      ];

      when(() => mockService.marcarTodasLeidas(55))
          .thenAnswer((_) async => Future.value());

      await viewModel.marcarTodas(55);

      expect(viewModel.notificaciones.every((n) => n["leida"] == true), true);
    });
  });
}
