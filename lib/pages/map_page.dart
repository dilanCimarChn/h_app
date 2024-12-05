import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng destinationPoint;

  const MapPage({
    required this.startPoint,
    required this.destinationPoint,
    Key? key,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _drawRoute();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeMarkers() {
    setState(() {
      // Marcador de inicio
      _markers.add(Marker(
        markerId: const MarkerId("start"),
        position: widget.startPoint,
        infoWindow: const InfoWindow(title: "Punto de Inicio"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
      // Marcador de destino
      _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: widget.destinationPoint,
        infoWindow: const InfoWindow(title: "Punto de Destino"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }

  Future<void> _drawRoute() async {
    _polylinePoints = PolylinePoints();

    // Realizar la solicitud a la API de Google Maps
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCcn_cdaHeJ2RK4Bxc4WoVjr8i8D8bmGPg', // Reemplaza con tu clave de API de Google
      PointLatLng(widget.startPoint.latitude, widget.startPoint.longitude),
      PointLatLng(widget.destinationPoint.latitude, widget.destinationPoint.longitude),
      travelMode: TravelMode.driving, // Puedes cambiar a walking o bicycling
    );

    if (result.points.isNotEmpty) {
      // Convertir los puntos a coordenadas LatLng
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        // Agregar la ruta como una polilínea en el mapa
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
    } else {
      // Mostrar un mensaje si no se pudo obtener la ruta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("verificando...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Ruta"),
        backgroundColor: const Color(0xFF3D405B),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: widget.startPoint,
          zoom: 12, // Nivel de zoom inicial
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}
