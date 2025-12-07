import 'package:flutter/material.dart';
import '../data/services/acceso_rapido_service.dart';

class AccesoRapidoViewModel extends ChangeNotifier {
  final AccesoRapidoService service; // solo uno
  int reservasActivas = 0;
  int favoritos = 0;
  bool isLoading = false;
  String? errorMessage;

  AccesoRapidoViewModel({AccesoRapidoService? service})
      : service = service ?? AccesoRapidoService();

  Future<void> fetchAccesos(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      // ✅ Usamos el service inyectado, no _service
      reservasActivas = await service.getReservasActivas(userId);
      favoritos = await service.getFavoritos(userId);

      errorMessage = null;

      debugPrint(
          "✅ Acceso rápido → reservas=$reservasActivas, favoritos=$favoritos");
    } catch (e) {
      errorMessage = "Error al cargar accesos rápidos: $e";
      debugPrint("❌ Error en fetchAccesos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
