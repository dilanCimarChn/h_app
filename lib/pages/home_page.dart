import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener los paquetes en tiempo real
  Stream<List<Map<String, dynamic>>> _getPaquetes() {
    return _firestore.collection('paquetes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tus paquetes",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A6476),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Color(0xFF2E3B4E),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getPaquetes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar los paquetes.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No tienes paquetes registrados.'));
                  }

                  final paquetes = snapshot.data!;
                  return ListView.builder(
                    itemCount: paquetes.length,
                    itemBuilder: (context, index) {
                      final paquete = paquetes[index];
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de visualización de paquetes
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
