import 'package:biblioverso_flutter/view/screens/login/login_screen.dart';
import 'package:biblioverso_flutter/viewmodel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Mock del LoginViewModel
class MockLoginViewModel extends Mock implements LoginViewModel {}

// Fake BuildContext para mocktail
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginViewModel mockLoginVM;

  setUpAll(() {
    mockLoginVM = MockLoginViewModel();
    registerFallbackValue(FakeBuildContext());
  });

  group('LoginScreen Integration Test', () {
    testWidgets('LoginScreen - renderizado y campos', (tester) async {
      // Mock de los controladores y estados
      when(() => mockLoginVM.emailController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.passwordController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.loading).thenReturn(false);
      when(() => mockLoginVM.login(any())).thenAnswer((_) async {});

      // Renderizamos la pantalla
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LoginViewModel>.value(
            value: mockLoginVM,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar widgets visibles
      expect(find.byKey(const Key('loginAnimation')), findsOneWidget);
      expect(find.byKey(const Key('loginTitle')), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.byKey(const Key('registerButton')), findsOneWidget);

      // Interacción con campos
      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      // Presionar login
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Verificar que se llamó al login
      verify(() => mockLoginVM.login(any())).called(1);
    });

    testWidgets('LoginScreen - mostrar loading', (tester) async {
      // Mock para estado loading
      when(() => mockLoginVM.emailController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.passwordController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.loading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LoginViewModel>.value(
            value: mockLoginVM,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar indicador de carga
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsNothing);
    });

    testWidgets('LoginScreen - navegar a registro', (tester) async {
      when(() => mockLoginVM.emailController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.passwordController)
          .thenReturn(TextEditingController());
      when(() => mockLoginVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/register': (context) => const Scaffold(body: Text('Registro')),
          },
          home: ChangeNotifierProvider<LoginViewModel>.value(
            value: mockLoginVM,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Presionar botón de registro
      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();

      // Verificar navegación
      expect(find.text('Registro'), findsOneWidget);
    });
  });
}
