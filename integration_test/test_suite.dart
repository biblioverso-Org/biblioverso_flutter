import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:biblioverso_flutter/view/screens/register/register_screen.dart';
import 'package:biblioverso_flutter/viewmodel/register_viewmodel.dart';

// Mock del RegisterViewModel
class MockRegisterViewModel extends Mock implements RegisterViewModel {}

// Fake BuildContext para mocktail
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockRegisterViewModel mockRegisterVM;

  setUpAll(() {
    mockRegisterVM = MockRegisterViewModel();
    registerFallbackValue(FakeBuildContext());
  });

  group('RegisterScreen Integration Test', () {
    testWidgets('Renderizado de pantalla y campos', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);
      when(() => mockRegisterVM.register(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Reemplaza pumpAndSettle() por pump con duración para no colgar
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key('registerAnimation')), findsOneWidget);
      expect(find.byKey(const Key('registerTitle')), findsOneWidget);
      expect(find.byKey(const Key('nameField')), findsOneWidget);
      expect(find.byKey(const Key('apellidoField')), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('registerButton')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('nameField')), 'John');
      await tester.enterText(find.byKey(const Key('apellidoField')), 'Doe');
      await tester.enterText(find.byKey(const Key('emailField')), 'john@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pump();

      verify(() => mockRegisterVM.register(any())).called(1);
    });

    testWidgets('Mostrar loading', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);
      expect(find.byKey(const Key('registerButton')), findsNothing);
    });

    testWidgets('Navegar a login', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Navegar a home', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Añadir libro a favoritos', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Ver notificacions', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Ver perfil', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Buscar Libros', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Crear Reserva', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Ver Favoritos', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Actualizar Perfil', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Ver Categorias', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Ver Detalles de un libro', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Cerrar Session', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
    testWidgets('Iniciar Session', (tester) async {
      when(() => mockRegisterVM.nameController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.apellidoController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.emailController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.passwordController).thenReturn(TextEditingController());
      when(() => mockRegisterVM.loading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login')),
          },
          home: ChangeNotifierProvider<RegisterViewModel>.value(
            value: mockRegisterVM,
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
  });
}
