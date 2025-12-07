import 'package:flutter/material.dart';
import '../data/services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final HomeService _service;

  List<Map<String, dynamic>> novedades = [];
  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> destacados = [];
  bool isLoadingDestacados = false;
  String? errorMessageDestacados;

  // 🔹 Constructor permite inyección de servicio para tests
  HomeViewModel({HomeService? service}) : _service = service ?? HomeService();

  void onTabTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> fetchNovedades() async {
    try {
      isLoading = true;
      notifyListeners();

      novedades = await _service.getNovedades();
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar novedades: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDestacados() async {
    try {
      isLoadingDestacados = true;
      notifyListeners();

      destacados = await _service.getDestacados();
      errorMessageDestacados = null;
    } catch (e) {
      errorMessageDestacados = "Error al cargar destacados: $e";
    } finally {
      isLoadingDestacados = false;
      notifyListeners();
    }
  }
}
