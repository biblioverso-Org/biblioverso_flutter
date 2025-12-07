import 'package:flutter_test/flutter_test.dart';
import 'package:biblioverso_flutter/data/models/categoria.dart';

void main() {
  test("Categoria.fromRow debe mapear correctamente", () {
    final categoria = Categoria.fromRow([1, "Terror", 20]);

    expect(categoria.idCategoria, 1);
    expect(categoria.nombre, "Terror");
    expect(categoria.cantidadLibros, 20);
  });
}
