import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:h_app/login/bienvenido.dart';
import 'package:h_app/login/inicia_sesion.dart';
import 'package:h_app/login/comienzaaviajar.dart';
import 'package:h_app/login/login_screen.dart';
import 'package:h_app/login/registrarse.dart';
import 'package:h_app/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializar Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helios App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Bienvenido(),
        '/login': (context) => IniciaSesion(),
        '/login_screen': (context) => LoginScreen(),
        '/registrarse': (context) => Registrarse(),
        '/comienzaviajar': (context) => ComienzaAViajarScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
