import 'package:flutter/material.dart';
import 'package:h_app/login/bienvenido.dart';
import 'package:h_app/login/inicia_sesion.dart';
import 'package:h_app/login/comienzaaviajar.dart';
import 'package:h_app/login/login_screen.dart';
import 'package:h_app/login/registrarse.dart';
import 'package:h_app/pages/main_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import necesario para LatLng

void main() {
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
      // Configura la pantalla inicial aquí
      initialRoute: '/', // Empieza desde Bienvenido
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
