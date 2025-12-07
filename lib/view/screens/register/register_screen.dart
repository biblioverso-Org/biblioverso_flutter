import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/register_viewmodel.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Lottie.asset(
                "lib/assets/animations/Register.json",
                width: 200,
                height: 200,
                key: const Key('registerAnimation'), // ✅ key
              ),
              const SizedBox(height: 20),
              Text(
                "Crear Cuenta",
                key: const Key('registerTitle'), // ✅ key
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                key: const Key('nameField'), // ✅ key
                controller: vm.nameController,
                decoration: const InputDecoration(
                  labelText: "Nombres",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                key: const Key('apellidoField'), // ✅ key
                controller: vm.apellidoController,
                decoration: const InputDecoration(
                  labelText: "Apellidos",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                key: const Key('emailField'), // ✅ key
                controller: vm.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                key: const Key('passwordField'), // ✅ key
                controller: vm.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              vm.loading
                  ? const CircularProgressIndicator(
                key: Key('loadingIndicator'), // ✅ key
              )
                  : ElevatedButton(
                key: const Key('registerButton'), // ✅ key
                onPressed: () => vm.register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Registrarse",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                key: const Key('loginButton'), // ✅ key
                onPressed: () => Navigator.pushNamed(context, "/login"),
                child: const Text("¿Ya tienes cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
