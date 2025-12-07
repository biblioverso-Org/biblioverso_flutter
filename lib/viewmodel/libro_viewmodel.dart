import 'package:flutter/material.dart';
import '../data/models/libro.dart';
import '../data/services/libro_service.dart';

/// Enum para definir los filtros de ordenamiento
enum LibroOrden { relevancia, titulo, editorial, disponibilidad, anio }

class LibroViewModel extends ChangeNotifier {
  final LibroService _service;

  LibroViewModel({LibroService? service}) : _service = service ?? LibroService();

  List<Libro> libros = [];
  bool isLoading = false;
  String? errorMessage;
  Libro? libroDetalle;

  // 🔹 Orden seleccionado
  LibroOrden _orden = LibroOrden.relevancia;
  LibroOrden get orden => _orden;

  Future<void> fetchLibrosByCategoria(int idCategoria) async {
    try {
      isLoading = true;
      notifyListeners();

      libros = await _service.getLibrosByCategoria(idCategoria);
      errorMessage = null;

      // Solo debug, no producción
      debugPrint("✅ Libros recibidos (${libros.length})");

      aplicarOrden(); // Orden inicial
    } catch (e) {
      errorMessage = "Error al cargar libros: $e";
      debugPrint("❌ Error en fetchLibrosByCategoria: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cambiar el filtro de ordenamiento
  void cambiarOrden(LibroOrden nuevo) {
    _orden = nuevo;
    aplicarOrden();
    notifyListeners();
  }

  /// Aplica el orden según el filtro seleccionado
  void aplicarOrden() {
    switch (_orden) {
      case LibroOrden.titulo:
        libros.sort((a, b) => a.titulo.compareTo(b.titulo));
        break;
      case LibroOrden.editorial:
        libros.sort((a, b) => (a.editorial ?? "").compareTo(b.editorial ?? ""));
        break;
      case LibroOrden.disponibilidad:
        libros.sort((a, b) => b.disponibles.compareTo(a.disponibles));
        break;
      case LibroOrden.anio:
        libros.sort((a, b) {
          final anioA = a.fechaPublicacion?.year ?? 0;
          final anioB = b.fechaPublicacion?.year ?? 0;
          return anioB.compareTo(anioA); // Más recientes primero
        });
        break;
      case LibroOrden.relevancia:
      // Aquí puedes implementar lógica de "relevancia" más adelante
        break;
    }
  }

  // Cargar detalle de libro
  Future<void> fetchLibroDetalle(int idLibro) async {
    try {
      isLoading = true;
      notifyListeners();
      libroDetalle = await _service.getLibroDetalle(idLibro);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error cargando detalle: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Agregar reseña
  Future<void> agregarOpinion(int libroId, int userId, int rating, String comment) async {
    await _service.addOpinion(libroId, userId, rating, comment);
    await fetchLibroDetalle(libroId); // refrescar
  }

  // Crear reserva
  Future<void> reservarLibro(int libroId, int userId, int cantidad) async {
    await _service.addReserva(libroId, userId, cantidad);
  }

}
