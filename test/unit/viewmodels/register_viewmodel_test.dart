import 'package:biblioverso_flutter/viewmodel/register_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/usuario_service.dart';
import 'package:biblioverso_flutter/data/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock de UsuarioService
class MockUsuarioService extends Mock implements UsuarioService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUsuarioService mockService;
  late RegisterViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // Resetea prefs antes de cada test
    mockService = MockUsuarioService();
    viewModel = RegisterViewModel(usuarioService: mockService);
  });

  testWidgets("register exitoso navega a /home y muestra SnackBar", (tester) async {
    final usuarioMock = Usuario(
      idUsuario: 1,
      email: "test@example.com",
      nombre: "Test",
    );

    // Mock del register
    when(() => mockService.register(any(), any(), any(), any()))
        .thenAnswer((_) async => usuarioMock);

    // Setear campos
    viewModel.nameController.text = "Test";
    viewModel.apellidoController.text = "User";
    viewModel.emailController.text = "test@example.com";
    viewModel.passwordController.text = "1234";

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          "/home": (_) => const Scaffold(body: Text("Home")),
        },
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => viewModel.register(context),
              child: const Text("Register"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Register"));
    await tester.pumpAndSettle();

    // Verificar navegación
    expect(find.text("Home"), findsOneWidget);

    // Verificar SnackBar
    expect(find.text("✅ Usuario registrado con éxito"), findsOneWidget);
  });

  testWidgets("register falla y muestra error", (tester) async {
    // Mock que devuelve null
    when(() => mockService.register(any(), any(), any(), any()))
        .thenAnswer((_) async => null);

    viewModel.nameController.text = "Test";
    viewModel.apellidoController.text = "User";
    viewModel.emailController.text = "fail@example.com";
    viewModel.passwordController.text = "1234";

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => viewModel.register(context),
              child: const Text("Register"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Register"));
    await tester.pumpAndSettle();

    // Verificar SnackBar de error
    expect(find.text("No se pudo registrar el usuario"), findsOneWidget);
  });
}
