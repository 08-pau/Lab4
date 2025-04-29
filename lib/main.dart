import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MiRedYMiRutaApp());
}

class MiRedYMiRutaApp extends StatelessWidget {
  const MiRedYMiRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      title: 'Mi Red y Mi Ruta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomePage(), // Tu pantalla principal
    );
  }
}
