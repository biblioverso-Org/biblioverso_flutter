import 'package:flutter_test/flutter_test.dart';
import 'package:biblioverso_flutter/viewmodel/opinion_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/opinion_service.dart';

// ---------- MOCK SERVICE ----------
class MockOpinionService extends OpinionService {
  List<Map<String, dynamic>> fakeOpiniones = [];

  @override
  Future<List<Map<String, dynamic>>> getOpiniones(int libroId) async {
    return fakeOpiniones;
  }

  @override
  Future<void> agregarOpinion(
      int userId, int libroId, int calificacion, String comentario) async {
    fakeOpiniones.add({
      "userId": userId,
      "libroId": libroId,
      "calificacion": calificacion,
      "comentario": comentario
    });
  }
}

// ---------- TEST ----------
void main() {
  late OpinionViewModel viewModel;
  late MockOpinionService mockService;

  setUp(() {
    mockService = MockOpinionService();
    viewModel = OpinionViewModel();

    // INYECTAR EL MOCK por encima del service real
    // ignore: invalid_use_of_visible_for_testing_member
    viewModel.setServiceForTest(mockService);
  });

  test("fetchOpiniones carga opiniones correctamente", () async {
    mockService.fakeOpiniones = [
      {"userId": 1, "libroId": 10, "calificacion": 5, "comentario": "Buen libro"}
    ];

    await viewModel.fetchOpiniones(10);

    expect(viewModel.opiniones.length, 1);
    expect(viewModel.errorMessage, null);
  });

  test("agregarOpinion agrega y recarga opiniones", () async {
    await viewModel.agregarOpinion(1, 10, 4, "Muy bueno");

    expect(viewModel.opiniones.length, 1);
    expect(viewModel.opiniones.first["comentario"], "Muy bueno");
  });
}
