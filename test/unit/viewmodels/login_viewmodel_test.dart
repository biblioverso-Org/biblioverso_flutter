import 'package:biblioverso_flutter/data/models/usuario.dart';
import 'package:biblioverso_flutter/viewmodel/login_viewmodel.dart';
import 'package:biblioverso_flutter/data/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock
class MockUsuarioService extends Mock implements UsuarioService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUsuarioService mockService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockService = MockUsuarioService();
  });

  testWidgets("login exitoso navega a /home", (tester) async {
    final usuario = Usuario(
      idUsuario: 1,
      email: "test@gmail.com",
      nombre: "Test",
    );

    when(() => mockService.login(any(), any()))
        .thenAnswer((_) async => usuario);

    final viewModel = LoginViewModel(usuarioService: mockService);

    viewModel.emailController.text = "test@gmail.com";
    viewModel.passwordController.text = "1234";

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          "/home": (_) => const Scaffold(body: Text("Home")),
        },
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => viewModel.login(context),
              child: const Text("Login"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    expect(find.text("Home"), findsOneWidget);
  });
}
