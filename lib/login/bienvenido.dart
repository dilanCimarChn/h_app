import 'package:flutter/material.dart';

class Bienvenido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3),
      body: GestureDetector(
        onPanUpdate: (details) {
          // Detectar deslizamientos para redirigir a la pantalla de Login
          if (details.delta.dx != 0 || details.delta.dy != 0) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/imagenes/logo.png',
                  height: 450,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Bienvenido a Helios",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3B4E),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Desliza para continuar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E3B4E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
