import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:biblioverso_flutter/viewmodel/favorites_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/favorites_service.dart';

class MockFavoritesService extends Mock implements FavoritesService {}

void main() {
  late FavoritesViewModel viewModel;
  late MockFavoritesService mockService;

  setUp(() {
    mockService = MockFavoritesService();
    viewModel = FavoritesViewModel(service: mockService);
  });

  test('estado inicial', () {
    expect(viewModel.favoritos, isEmpty);
    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, null);
  });

  test('agregar favorito llama al servicio correctamente', () async {
    when(() => mockService.addFavorito(1,1)).thenAnswer((_) async => Future.value());

    await viewModel.addFavorito(1,1);

    verify(() => mockService.addFavorito(1,1)).called(1);
  });
}
