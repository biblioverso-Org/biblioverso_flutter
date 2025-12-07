import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblioverso_flutter/core/utils/session_manager.dart';
import 'package:biblioverso_flutter/data/models/usuario.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("SessionManager Tests", () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test("Guardar y obtener datos del usuario (map)", () async {
      final user = {
        "id_usuario": 1,
        "usuario": "miguel",
        "email": "test@mail.com",
      };

      await SessionManager.saveUserData(user);

      final data = await SessionManager.getUserData();

      expect(data["id_usuario"], 1);
      expect(data["usuario"], "miguel");
      expect(data["email"], "test@mail.com");
    });

    test("saveLoginSession debe guardar correctamente un Usuario", () async {
      final usuario = Usuario(
        idUsuario: 10,
        usuario: "john",
        email: "john@mail.com",
      );

      await SessionManager.saveLoginSession(usuario);

      final prefs = await SharedPreferences.getInstance();

      expect(prefs.getInt("id_usuario"), 10);
      expect(prefs.getString("usuario"), "john");
      expect(prefs.getString("email"), "john@mail.com");
    });

    test("isLoggedIn debe retornar true", () async {
      SharedPreferences.setMockInitialValues({"id_usuario": 1});
      expect(await SessionManager.isLoggedIn(), true);
    });

    test("clearSession debe borrar todo", () async {
      SharedPreferences.setMockInitialValues({"id_usuario": 5});

      await SessionManager.clearSession();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().isEmpty, true);
    });
  });
}
