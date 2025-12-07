import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/home_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/home_service.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  late HomeViewModel viewModel;
  late MockHomeService mockService;

  setUp(() {
    mockService = MockHomeService();
    viewModel = HomeViewModel(service: mockService);
  });

  test('estado inicial', () {
    expect(viewModel.selectedIndex, 0);
    expect(viewModel.novedades, isEmpty);
    expect(viewModel.destacados, isEmpty);
    expect(viewModel.isLoading, false);
    expect(viewModel.isLoadingDestacados, false);
    expect(viewModel.errorMessage, null);
    expect(viewModel.errorMessageDestacados, null);
  });

  test('onTabTapped cambia selectedIndex', () {
    viewModel.onTabTapped(2);
    expect(viewModel.selectedIndex, 2);
  });

  test('fetchNovedades carga correctamente', () async {
    final mockNovedades = [
      {"id": 1, "titulo": "Libro Test"}
    ];
    when(() => mockService.getNovedades())
        .thenAnswer((_) async => mockNovedades);

    await viewModel.fetchNovedades();

    expect(viewModel.novedades, mockNovedades);
    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, null);

    verify(() => mockService.getNovedades()).called(1);
  });

  test('fetchDestacados carga correctamente', () async {
    final mockDestacados = [
      {"id": 1, "titulo": "Destacado Test"}
    ];
    when(() => mockService.getDestacados())
        .thenAnswer((_) async => mockDestacados);

    await viewModel.fetchDestacados();

    expect(viewModel.destacados, mockDestacados);
    expect(viewModel.isLoadingDestacados, false);
    expect(viewModel.errorMessageDestacados, null);

    verify(() => mockService.getDestacados()).called(1);
  });

  test('fetchNovedades maneja errores correctamente', () async {
    when(() => mockService.getNovedades()).thenThrow(Exception('Error Novedades'));

    await viewModel.fetchNovedades();

    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('fetchDestacados maneja errores correctamente', () async {
    when(() => mockService.getDestacados()).thenThrow(Exception('Error Destacados'));

    await viewModel.fetchDestacados();

    expect(viewModel.isLoadingDestacados, false);
    expect(viewModel.errorMessageDestacados, isNotNull);
  });
}
