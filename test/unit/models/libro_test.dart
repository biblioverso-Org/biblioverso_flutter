import 'package:flutter_test/flutter_test.dart';
import 'package:biblioverso_flutter/data/models/libro.dart';

void main() {
  test("Libro.fromRow debe mapear correctamente", () {
    final libro = Libro.fromRow([
      10, "Harry Potter", "portada.jpg", "sinopsis",
      "Editorial", "2020-01-01", 5
    ]);

    expect(libro.idLibro, 10);
    expect(libro.titulo, "Harry Potter");
    expect(libro.disponibles, 5);
  });

  test("Libro.fromDetailRow debe mapear correctamente", () {
    final libro = Libro.fromDetailRow([
      1, "12345", "El libro", "sinopsis", "editorial",
      "2020-05-05", "portada.png", "Fantasía", "Autor", 3, 4.5, 10
    ]);

    expect(libro.isbn, "12345");
    expect(libro.categoria, "Fantasía");
    expect(libro.reviews, 10);
  });
}
