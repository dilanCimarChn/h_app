import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF3E3), // Color de fondo suave
      appBar: AppBar(
        backgroundColor: Color(0xFF2E3B4E),
        title: Row(
          children: [
            Icon(Icons.local_shipping, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text(
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
            // Encabezado
            Text(
              "Tus paquetes",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A6476), // Tono claro para contraste
              ),
            ),
            Divider(
              thickness: 2,
              color: Color(0xFF2E3B4E),
            ),
            SizedBox(height: 16),
            // Lista de paquetes
            Expanded(
              child: ListView(
                children: [
                  _buildPackageCard(
                    context,
                    "Juguetes BJ-2179",
                    "De La Paz a Cochabamba",
                    "Hoy 06:25 am",
                  ),
                  _buildPackageCard(
                    context,
                    "Juguetes CJ-1248",
                    "De La Paz a Tarija",
                    "Hoy 06:25 am",
                  ),
                  _buildPackageCard(
                    context,
                    "Juguetes - 206",
                    "De Cochabamba a Tarija",
                    "Hoy 06:25 am",
                  ),
                ],
              ),
            ),
            // Botón recargar
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción del botón
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Recargando paquetes...')),
                  );
                },
                icon: Icon(Icons.refresh),
                label: Text(
                  "Recargar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFAF3E3), // Contraste claro
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E3B4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(
      BuildContext context, String title, String route, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFD88C6A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            Text(
              route,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
