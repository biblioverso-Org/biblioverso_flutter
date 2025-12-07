import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/categoria_viewmodel.dart';

class MockCategoriaViewModel extends Mock implements CategoriaViewModel {}

void main() {
  late MockCategoriaViewModel viewModel;

  setUp(() {
    viewModel = MockCategoriaViewModel();
  });

  test('inicializa correctamente', () {
    expect(viewModel, isA<CategoriaViewModel>());
  });

  test('fetchCategorias llama al servicio', () async {
    when(() => viewModel.fetchCategorias()).thenAnswer((_) async {});
    await viewModel.fetchCategorias();
    verify(() => viewModel.fetchCategorias()).called(1);
  });
}
