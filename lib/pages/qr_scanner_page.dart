import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main_screen.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  QRScannerPageState createState() => QRScannerPageState();
}

class QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isScanning = false;

  void pauseCamera() => _controller.stop(); // Pausa la cámara
  void resumeCamera() => _controller.start(); // Reanuda la cámara

  Future<void> _scanFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Procesando imagen seleccionada...')),
      );
      // Aquí estaría la lógica de escaneo desde la galería
    }
  }

  void _processQRCode(String? code) {
    if (code != null) {
      final data = code.split(',');
      if (data.length == 4) {
        try {
          final startPoint = LatLng(
            double.parse(data[0]),
            double.parse(data[1]),
          );
          final destinationPoint = LatLng(
            double.parse(data[2]),
            double.parse(data[3]),
          );

          // Llama al método del padre para actualizar la página del mapa
          final mainScreenState =
              context.findAncestorStateOfType<MainScreenState>();
          if (mainScreenState != null) {
            mainScreenState.updateMapPage(startPoint, destinationPoint);

            // Cambia al mapa
            mainScreenState.onTabTapped(2); // Cambia a la pestaña del mapa
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formato del QR no válido.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El QR debe contener 4 coordenadas.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E3),
      appBar: AppBar(
        title: const Text(
          "Escáner QR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF3D405B), // Fondo oscuro para la AppBar
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            _controller.stop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Vista de la cámara para escanear QR
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && !_isScanning) {
                  _isScanning = true;
                  final code = barcodes.first.rawValue;
                  _processQRCode(code); // Procesa el código escaneado
                  Future.delayed(const Duration(seconds: 2), () {
                    _isScanning = false;
                  });
                }
              },
            ),
          ),
          // Contenedor para el texto y botón
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 60,
                    color: Color(0xFF3D405B),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Coloca el código QR en el marco para escanear',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3D405B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scanFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D405B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      'Escanear desde galería',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
