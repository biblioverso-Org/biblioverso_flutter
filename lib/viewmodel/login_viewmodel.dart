import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';
import '../data/services/usuario_service.dart';
import '../data/models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final UsuarioService _usuarioService;

  LoginViewModel({UsuarioService? usuarioService})
      : _usuarioService = usuarioService ?? UsuarioService();

  bool _loading = false;
  bool get loading => _loading;

  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;

  String? _error;
  String? get error => _error;

  Future<void> login(BuildContext context) async {
    _setLoading(true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final user = await _usuarioService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!context.mounted) return;

      if (user != null) {
        _usuarioActual = user;

        await SessionManager.saveLoginSession(user);

        if (!context.mounted) return;

        _setLoading(false);
        navigator.pushReplacementNamed("/home");
      } else {
        _setError("Correo o contraseña incorrectos", messenger);
      }
    } catch (e) {
      if (!context.mounted) return;
      _setError("Error al conectar con NeonDB: $e", messenger);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String message, ScaffoldMessengerState messenger) {
    _error = message;
    notifyListeners();
    messenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
