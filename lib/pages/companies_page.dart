import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompaniesPage extends StatelessWidget {
  // Función para abrir la URL externa
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D405B), // Azul oscuro
        title: const Text(
          'Empresas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        color: const Color(0xFFF4F1DE), // Fondo pastel claro
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: ListView(
          children: [
            _buildCompanyCard(
              context,
              'Bolivar',
              'assets/imagenes/bolivarlogo.png',
              'https://www.facebook.com/FlotaBolivar/?locale=es_LA',
              'https://wa.me/59178322540',
            ),
            _buildCompanyCard(
              context,
              'Trans. Copacabana S.A.',
              'assets/imagenes/transCopacabana-logo.png',
              'https://transcopacabanasa.com.bo/',
              'https://wa.me/59172233555',
            ),
            _buildCompanyCard(
              context,
              'El Dorado',
              'assets/imagenes/el_dorado-logo.png',
              'https://www.flotaeldorado.com/',
              'https://wa.me/59176400493',
            ),
            // Añade más tarjetas según sea necesario...
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(
    BuildContext context,
    String companyName,
    String logoPath,
    String facebookUrl,
    String whatsappUrl,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo y nombre
            Image.asset(
              logoPath,
              height: 80, // Más ancho y alto para mayor visibilidad
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              companyName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D405B),
              ),
            ),
            const SizedBox(height: 16),
            // Botones de acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _launchURL(facebookUrl);
                  },
                  icon: const FaIcon(FontAwesomeIcons.facebook),
                  label: const Text('Facebook'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4267B2), // Azul Facebook
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _launchURL(whatsappUrl);
                  },
                  icon: const FaIcon(FontAwesomeIcons.whatsapp),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // Verde WhatsApp
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
