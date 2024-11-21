import 'package:flutter/material.dart';

class ComienzaAViajarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3), // Fondo beige
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF2E3B4E)), // Icono de cerrar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto principal
            const Text(
              "¡Te has registrado con éxito!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3B4E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Imagen del carro
            Image.asset(
              'assets/imagenes/carro.png', // Asegúrate de que la imagen esté en esta ruta
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 5),
            // Botón "Comienza a viajar"
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD88C6A), // Color terracota
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 80,
                ),
              ),
              child: const Text(
                "Comienza a viajar",
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
    );
  }
}
