import 'package:flutter/material.dart';
import 'home_page.dart';
import 'qr_scanner_page.dart';
import 'map_page.dart';
import 'price_estimator_page.dart';
import 'companies_page.dart';
import 'extra_services_page.dart';
import '../widgets/nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  LatLng? _startPoint;
  LatLng? _destinationPoint;

  late final List<Widget> _pages;
  final GlobalKey<QRScannerPageState> _qrScannerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      QRScannerPage(key: _qrScannerKey),
      _buildMapPage(),
      PriceEstimatorPage(),
      CompaniesPage(),
      ExtraServicesPage(),
    ];
  }

  Widget _buildMapPage() {
    if (_startPoint != null && _destinationPoint != null) {
      return MapPage(
        startPoint: _startPoint!,
        destinationPoint: _destinationPoint!,
      );
    }
    return const Center(
      child: Text(
        'No hay una ruta definida. Escanea un QR válido para obtener la ruta.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  void updateMapPage(LatLng startPoint, LatLng destinationPoint) {
    setState(() {
      _startPoint = startPoint;
      _destinationPoint = destinationPoint;
      _pages[2] = _buildMapPage();
    });
  }

  void onTabTapped(int index) {
    setState(() {
      if (_currentIndex == 1 && index != 1) {
        _qrScannerKey.currentState?.pauseCamera();
      }
      if (_currentIndex != 1 && index == 1) {
        _qrScannerKey.currentState?.resumeCamera();
      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
