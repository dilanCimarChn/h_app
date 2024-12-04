import 'package:flutter/material.dart';

class Registrarse extends StatefulWidget {
  @override
  _RegistrarseState createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  bool _obscurePassword = true;

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
            // Campo de texto para Nombre
            TextField(
              decoration: InputDecoration(
                hintText: "Nombre",
                filled: true,
                fillColor: const Color(0xFFFDFCFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Campo de texto para Correo
            TextField(
              decoration: InputDecoration(
                hintText: "Correo",
                filled: true,
                fillColor: const Color(0xFFFDFCFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Campo de texto para Contraseña
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Contraseña",
                filled: true,
                fillColor: const Color(0xFFFDFCFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF2E3B4E),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botón "Continuar"
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/comienzaviajar');
              },
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
                "Continuar",
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

