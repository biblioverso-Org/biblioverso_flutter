import 'package:flutter/material.dart';
import '../data/services/reservations_service.dart';

class ReservationsViewModel extends ChangeNotifier {
  final ReservationsService _service;

  ReservationsViewModel({ReservationsService? service})
      : _service = service ?? ReservationsService();

  List<Map<String, dynamic>> activeReservations = [];
  List<Map<String, dynamic>> historyReservations = [];

  bool isLoading = false;
  String? errorMessage;
  int tabIndex = 0;

  /// Cambiar de tab
  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future<void> fetchReservas(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final allReservas = await _service.getReservas(userId);

      // Filtrar por estado
      activeReservations = allReservas.where((r) {
        final estado = r["estado"].toString().toLowerCase();
        return estado == "pendiente" || estado == "espera" || estado == "recoger";
      }).toList();

      historyReservations = allReservas.where((r) {
        final estado = r["estado"].toString().toLowerCase();
        return estado == "cancelado" || estado == "completada";
      }).toList();

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar reservas: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cancelar reserva
  Future<void> cancelReserva(int reservaId) async {
    try {
      await _service.cancelarReserva(reservaId);
      // refrescar reservas
      // (necesitamos el userId, puedes pasarlo en el constructor o guardarlo en ProfileVM)
    } catch (e) {
      errorMessage = "Error al cancelar la reserva: $e";
      notifyListeners();
    }
  }

  /// Reservar un libro
  Future<void> reservarLibro(int userId, int libroId, int cantidad) async {
    await _service.reservarLibro(userId, libroId, cantidad);
    await fetchReservas(userId);
  }

  /// Unirse a lista de espera
  Future<void> unirseListaEspera(int userId, int libroId) async {
    await _service.unirseListaEspera(userId, libroId);
    await fetchReservas(userId);
  }
}
