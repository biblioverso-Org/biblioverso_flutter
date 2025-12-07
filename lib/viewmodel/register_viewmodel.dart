import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';
import '../data/services/usuario_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final UsuarioService _usuarioService;

  RegisterViewModel({UsuarioService? usuarioService})
      : _usuarioService = usuarioService ?? UsuarioService();

  bool _loading = false;
  bool get loading => _loading;

// ✅ usado internamente

  Future<void> register(BuildContext context) async {
    _setLoading(true);

    // ✅ Capturamos referencias antes de async gaps
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final user = await _usuarioService.register(
        nameController.text.trim(),
        apellidoController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!context.mounted) return;

      if (user != null) {
// ahora sí se asigna y usa

        // Guardar sesión al registrarse
        await SessionManager.saveLoginSession(user);

        if (!context.mounted) return;

        messenger.showSnackBar(
          const SnackBar(content: Text("✅ Usuario registrado con éxito")),
        );

        navigator.pushReplacementNamed("/home");
      } else {
        _showError(messenger, "No se pudo registrar el usuario");
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(messenger, "Error en el registro: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _showError(ScaffoldMessengerState messenger, String msg) {
    messenger.showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
