import 'package:flutter/material.dart';

class IniciaSesion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3), // Fondo beige
      body: Column(
        children: [
          // Sección superior con logo
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                'assets/imagenes/logo.png',
                height: 400,
                width: 400,
              ),
            ),
          ),
          // Sección inferior con botones
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2E3B4E), // Azul oscuro
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón "Inicia Sesión"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login_screen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD88C6A), // Color terracota
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      ),
                      child: const Text(
                        "Inicia Sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón "Regístrate"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registrarse');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF), // Azul
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      ),
                      child: const Text(
                        "Regístrate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
