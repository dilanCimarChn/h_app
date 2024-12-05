import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Paquete para abrir enlaces en el navegador
import 'qr_scanner_page.dart'; // Asegúrate de que esta ruta sea correcta

class ExtraServicesPage extends StatefulWidget {
  const ExtraServicesPage({Key? key}) : super(key: key);

  @override
  State<ExtraServicesPage> createState() => _ExtraServicesPageState();
}

class _ExtraServicesPageState extends State<ExtraServicesPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Widget> _messages = []; // Lista para almacenar mensajes

  void _handleMessage(String message) {
    setState(() {
      // Añadimos el mensaje del usuario al chat
      _messages.add(_buildUserMessage(message));

      // Generamos la respuesta del chatbot según el mensaje del usuario
      if (message.toLowerCase().contains('qr')) {
        _messages.add(_buildBotMessageWithQRButton());
      } else if (message.toLowerCase().contains('pedidos ya')) {
        _messages.add(_buildBotMessageWithPedidosYaButton());
      } else {
        _messages.add(_buildBotMessage('Lo siento, no entiendo tu solicitud.'));
      }
    });
    _messageController.clear(); // Limpiamos el campo de texto
  }

  Widget _buildUserMessage(String message) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBotMessage(String message) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBotMessageWithQRButton() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Claro! Puedes ir al escáner QR haciendo clic en el botón de abajo:',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D405B),
              ),
              child: const Text(
                'Ir al Escáner QR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotMessageWithPedidosYaButton() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Entendido! Puedes gestionar Pedidos Ya desde aquí:',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                const url = 'https://www.pedidosya.com.bo/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'No se pudo abrir $url';
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color característico de Pedidos Ya
              ),
              child: const Text(
                'Ir a Pedidos Ya',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot de Servicios'),
        backgroundColor: const Color(0xFF3D405B),
      ),
      body: Column(
        children: [
          // Sección de mensajes
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          // Campo de texto para enviar mensajes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _handleMessage(_messageController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D405B),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}