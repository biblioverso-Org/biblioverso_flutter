import 'package:flutter/material.dart';
import '../data/services/notificaciones_service.dart';

class NotificacionesViewModel extends ChangeNotifier {
  NotificacionesService _service = NotificacionesService(); // ← ya no es final

  List<Map<String, dynamic>> notificaciones = [];
  bool isLoading = false;
  String? errorMessage;

  // ✔️ Solo para tests (no afecta producción)
  void setServiceForTest(NotificacionesService service) {
    _service = service;
  }

  Future<void> fetchNotificaciones(int userId) async {
    try {
      isLoading = true;
      notifyListeners();
      notificaciones = await _service.getNotificaciones(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar notificaciones: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> marcarLeida(int id) async {
    await _service.marcarLeida(id);
    notificaciones = notificaciones.map((n) {
      if (n["id"] == id) return {...n, "leida": true};
      return n;
    }).toList();
    notifyListeners();
  }

  Future<void> marcarTodas(int userId) async {
    await _service.marcarTodasLeidas(userId);
    notificaciones = notificaciones.map((n) => {...n, "leida": true}).toList();
    notifyListeners();
  }
}
