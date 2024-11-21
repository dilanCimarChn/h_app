import 'package:flutter/material.dart';

class ExtraServicesPage extends StatefulWidget {
  @override
  _ExtraServicesPageState createState() => _ExtraServicesPageState();
}

class _ExtraServicesPageState extends State<ExtraServicesPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Preguntas Frecuentes y Sugerencias
  Map<String, String> faqResponses = {
    "envío": "Los envíos se realizan entre las principales ciudades de Bolivia. El tiempo estimado es de 24 a 48 horas.",
    "seguimiento": "Puedes rastrear tu paquete desde la sección 'Tus Paquetes' en la pantalla principal.",
    "precio": "El costo del envío depende del peso, volumen, y distancia entre origen y destino.",
    "paquete perdido": "Por favor, contacta a soporte en el siguiente enlace: soporte@helios.com.",
  };

  Map<String, List<String>> serviceSuggestions = {
    "comida": ["PedidosYa", "UberEats", "Rappi"],
    "mantenimiento": ["Plomero Express", "Electricista Bolivia"],
    "limpieza": ["Lavandería Plus", "Limpieza Express"],
    "paquetería a domicilio": ["Reparto Helios", "Paquete a Casa"],
  };

  Future<String> _sendMessageToAPI(String message) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Simula la espera de una API

    setState(() {
      _isLoading = false;
    });

    // Busca en FAQ
    for (var key in faqResponses.keys) {
      if (message.toLowerCase().contains(key)) {
        return faqResponses[key]!;
      }
    }

    // Busca sugerencias de servicios
    for (var category in serviceSuggestions.keys) {
      if (message.toLowerCase().contains(category)) {
        return "Para ${category}, te recomendamos: ${serviceSuggestions[category]!.join(", ")}.";
      }
    }

    // Respuesta predeterminada
    return "Lo siento, no entendí tu pregunta. Por favor, intenta con algo más específico.";
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": _messageController.text});
    });

    String response = await _sendMessageToAPI(_messageController.text);

    setState(() {
      _messages.add({"sender": "bot", "text": response});
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF3E3),
      appBar: AppBar(
        title: Text(
          "Asistente Virtual",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(0xFF2E3B4E),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                bool isUserMessage = message['sender'] == "user";

                return Align(
                  alignment:
                      isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Color(0xFF2E3B4E) : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: isUserMessage
                            ? Radius.circular(12)
                            : Radius.circular(0),
                        bottomRight: isUserMessage
                            ? Radius.circular(0)
                            : Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircularProgressIndicator(
                color: Color(0xFF2E3B4E),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Escribe tu consulta aquí...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF2E3B4E),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
