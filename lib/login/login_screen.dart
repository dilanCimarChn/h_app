import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuario-app')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Guardar el correo en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserEmail', email);

        // Usuario encontrado
        Navigator.pushReplacementNamed(context, '/comienzaviajar');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF2E3B4E)),
        title: const Text(
          "Iniciar Sesión",
          style: TextStyle(
            color: Color(0xFF2E3B4E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/logo.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "HELIOS",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3B4E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
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
              TextField(
                controller: _passwordController,
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
              ElevatedButton(
                onPressed: _loginUser,
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
                  "Iniciar Sesión",
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
    );
  }
}
