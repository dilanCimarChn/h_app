import 'package:flutter/material.dart';
import 'package:h_app/services/google_auth_service.dart';

class Registrarse extends StatefulWidget {
  @override
  _RegistrarseState createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  void _registerWithGoogle() async {
    try {
      final user = await _googleAuthService.signInWithGoogle();
      if (user != null) {
        // Usuario autenticado con éxito
        print("Inicio de sesión exitoso con Google: ${user.email}");
        // Aquí puedes redirigir a otra pantalla o realizar acciones adicionales
      } else {
        // Usuario canceló el inicio de sesión
        print("El usuario canceló el inicio de sesión.");
      }
    } catch (e) {
      // Manejo de errores
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Error al registrar con Google: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cerrar"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3), // Fondo beige
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF2E3B4E)), // Icono de cerrar
        title: const Text(
          "Registrarse",
          style: TextStyle(
            color: Color(0xFF2E3B4E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/imagenes/logo.png',
                height: 320,
                width: 320,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3B4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 80,
                ),
              ),
              child: const Text(
                "Registrarse con Google",
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
