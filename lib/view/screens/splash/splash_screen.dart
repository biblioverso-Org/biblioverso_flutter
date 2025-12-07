import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);
    splashVM.startSplashTimer(context);

    splashVM.addListener(() {
      if (splashVM.isFinished) {
        // Cuando termine, redirigimos (puedes cambiar a Onboarding, Home, etc.)
        Navigator.pushReplacementNamed(context, "/onboarding");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('splashScreen'),
      backgroundColor: Colors.white, // color principal de la marca
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación Lottie
            Lottie.asset(
              "lib/assets/animations/books.json", // coloca aquí tu animación
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // // Texto de marca
            // Text(
            //   "Biblioverso",
            //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
