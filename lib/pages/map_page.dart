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
      _markers.add(Marker(
        markerId: const MarkerId("start"),
        position: widget.startPoint,
        infoWindow: const InfoWindow(title: "Terminal de Buses La Paz"),
      ));
      _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: widget.destinationPoint,
        infoWindow: const InfoWindow(title: "Terminal de Buses Cochabamba"),
      ));
    });
  }

  Future<void> _drawRoute() async {
    _polylinePoints = PolylinePoints();
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(widget.startPoint.latitude, widget.startPoint.longitude),
        destination: PointLatLng(widget.destinationPoint.latitude, widget.destinationPoint.longitude),
        mode: TravelMode.driving, // Modo de transporte
      ),
      googleApiKey: 'YOUR_GOOGLE_API_KEY', // Reemplaza con tu API Key
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo trazar la ruta.")),
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
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}
