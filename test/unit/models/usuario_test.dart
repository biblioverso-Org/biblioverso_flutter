import 'package:flutter_test/flutter_test.dart';
import 'package:biblioverso_flutter/data/models/usuario.dart';

void main() {
  test("Usuario.fromRow debe mapear correctamente", () {
    final usuario = Usuario.fromRow([
      1, "miguel", "123", "Miguel", "Moya",
      "mail@mail.com", "777", "calle", "M",
      "2000-01-01", "Bolivia", "bio", "foto.png"
    ]);

    expect(usuario.idUsuario, 1);
    expect(usuario.usuario, "miguel");
    expect(usuario.email, "mail@mail.com");
  });
}
