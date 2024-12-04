import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userEmail;
  String? _userName;

  List<Map<String, dynamic>> _paquetes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('loggedInUserEmail');

    if (email != null) {
      setState(() {
        _userEmail = email;
      });

      final querySnapshot = await _firestore
          .collection('usuario-app')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _userName = querySnapshot.docs.first.data()['name'];
        });
      }
    }

    // Cargar los paquetes inicialmente
    await _fetchPaquetes();
  }

  Future<void> _fetchPaquetes() async {
    if (_userEmail == null) return;

    setState(() {
      _isLoading = true;
    });

    final paquetesRemitenteQuery = await _firestore
        .collection('paquetes')
        .where('remitente.correo', isEqualTo: _userEmail)
        .get();

    final paquetesDestinatarioQuery = await _firestore
        .collection('paquetes')
        .where('destinatario.correo', isEqualTo: _userEmail)
        .get();

    final paquetesRemitente = paquetesRemitenteQuery.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    final paquetesDestinatario = paquetesDestinatarioQuery.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      _paquetes = [...paquetesRemitente, ...paquetesDestinatario];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3B4E),
        title: Row(
          children: [
            const Icon(Icons.local_shipping, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            const Text(
              'HELIOS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPaquetes, // Llamar al método para recargar los datos
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Tus paquetes",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A6476),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_userName != null)
                          Text(
                            "($_userName)",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF5A6476),
                            ),
                          ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      color: Color(0xFF2E3B4E),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _paquetes.isEmpty
                          ? const Center(
                              child: Text('No tienes paquetes registrados.'),
                            )
                          : ListView.builder(
                              itemCount: _paquetes.length,
                              itemBuilder: (context, index) {
                                final paquete = _paquetes[index];
                                return _buildPackageCard(
                                  remitente: paquete['remitente']['nombre'] ?? 'Sin remitente',
                                  destinatario: paquete['destinatario']['nombre'] ?? 'Sin destinatario',
                                  tipo: paquete['detallesPaquete']['tipo'] ?? 'Sin tipo',
                                  fecha: paquete['fechaEnvio'] ?? 'Sin fecha',
                                  hora: paquete['horaEnvio'] ?? 'Sin hora',
                                  peso: paquete['detallesPaquete']['peso']?.toString() ?? 'N/A',
                                  precio: paquete['detallesPaquete']['precio']?.toString() ?? 'N/A',
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPackageCard({
    required String remitente,
    required String destinatario,
    required String tipo,
    required String fecha,
    required String hora,
    required String peso,
    required String precio,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD88C6A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remitente: $remitente",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Destinatario: $destinatario",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tipo de paquete: $tipo",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Fecha de envío: $fecha",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              "Hora de envío: $hora",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Peso: $peso kg",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              "Precio: $precio Bs",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
