import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/libro_viewmodel.dart';
import 'package:biblioverso_flutter/data/models/libro.dart';
import 'package:biblioverso_flutter/data/services/libro_service.dart';

// Mock del servicio
class MockLibroService extends Mock implements LibroService {}

void main() {
  late LibroViewModel viewModel;
  late MockLibroService mockService;

  final mockLibros = [
    Libro(idLibro: 1, titulo: 'B Libro', editorial: 'Editorial A', disponibles: 5, fechaPublicacion: DateTime(2022, 5, 20)),
    Libro(idLibro: 2, titulo: 'A Libro', editorial: 'Editorial B', disponibles: 2, fechaPublicacion: DateTime(2023, 3, 15)),
  ];

  final mockDetalle = Libro(idLibro: 1, titulo: 'Detalle Libro', editorial: 'Editorial X', disponibles: 3, fechaPublicacion: DateTime(2021, 7, 10));

  setUp(() {
    mockService = MockLibroService();
    viewModel = LibroViewModel(service: mockService);
  });

  test('estado inicial', () {
    expect(viewModel.libros, isEmpty);
    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, null);
    expect(viewModel.orden, LibroOrden.relevancia);
    expect(viewModel.libroDetalle, null);
  });

  test('fetchLibrosByCategoria carga correctamente y aplica orden', () async {
    when(() => mockService.getLibrosByCategoria(1)).thenAnswer((_) async => mockLibros);

    final future = viewModel.fetchLibrosByCategoria(1);

    expect(viewModel.isLoading, true);

    await future;

    expect(viewModel.libros.length, 2);
    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, null);

    verify(() => mockService.getLibrosByCategoria(1)).called(1);
  });

  test('fetchLibrosByCategoria maneja errores', () async {
    when(() => mockService.getLibrosByCategoria(1)).thenThrow(Exception('Error'));

    await viewModel.fetchLibrosByCategoria(1);

    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('cambiarOrden ordena los libros correctamente', () async {
    when(() => mockService.getLibrosByCategoria(1)).thenAnswer((_) async => mockLibros);

    await viewModel.fetchLibrosByCategoria(1);

    viewModel.cambiarOrden(LibroOrden.titulo);
    expect(viewModel.libros.first.titulo, 'A Libro');

    viewModel.cambiarOrden(LibroOrden.editorial);
    expect(viewModel.libros.first.editorial, 'Editorial A');
  });

  test('fetchLibroDetalle carga correctamente', () async {
    when(() => mockService.getLibroDetalle(1)).thenAnswer((_) async => mockDetalle);

    await viewModel.fetchLibroDetalle(1);

    expect(viewModel.libroDetalle?.titulo, 'Detalle Libro');
    expect(viewModel.errorMessage, null);
    verify(() => mockService.getLibroDetalle(1)).called(1);
  });

  test('fetchLibroDetalle maneja errores', () async {
    when(() => mockService.getLibroDetalle(1)).thenThrow(Exception('Error detalle'));

    await viewModel.fetchLibroDetalle(1);

    expect(viewModel.errorMessage, isNotNull);
  });

  test('agregarOpinion llama a addOpinion y refresca detalle', () async {
    when(() => mockService.addOpinion(1, 1, 5, 'Comentario')).thenAnswer((_) async {});
    when(() => mockService.getLibroDetalle(1)).thenAnswer((_) async => mockDetalle);

    await viewModel.agregarOpinion(1, 1, 5, 'Comentario');

    verify(() => mockService.addOpinion(1, 1, 5, 'Comentario')).called(1);
    verify(() => mockService.getLibroDetalle(1)).called(1);
  });

  test('reservarLibro llama a addReserva', () async {
    when(() => mockService.addReserva(1, 1, 2)).thenAnswer((_) async {});

    await viewModel.reservarLibro(1, 1, 2);

    verify(() => mockService.addReserva(1, 1, 2)).called(1);
  });
}
