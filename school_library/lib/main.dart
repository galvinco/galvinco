
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GalvinsLibraryApp());
}

class GalvinsLibraryApp extends StatelessWidget {
  const GalvinsLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Galvin's-Library",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121622),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD99B26),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
