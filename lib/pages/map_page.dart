import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  Location _location = Location();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _getCurrentLocation();
    _drawRoute();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // Configura los marcadores iniciales
  void _initializeMarkers() {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId("start"),
        position: widget.startPoint,
        infoWindow: const InfoWindow(title: "Punto de Inicio"),
      ));

      _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: widget.destinationPoint,
        infoWindow: const InfoWindow(title: "Destino"),
      ));
    });
  }

  // Obtiene la ubicación actual del dispositivo
  void _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        _markers.add(Marker(
          markerId: const MarkerId("current"),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Ubicación Actual"),
        ));
      });

      _location.onLocationChanged.listen((locationData) {
        if (!mounted) return;

        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          _markers.removeWhere((marker) => marker.markerId.value == "current");
          _markers.add(Marker(
            markerId: const MarkerId("current"),
            position: _currentLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Ubicación Actual"),
          ));
        });
      });
    } catch (e) {
      print("Error al obtener la ubicación actual: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo obtener la ubicación actual."),
          ),
        );
      }
    }
  }

  // Dibuja la ruta entre el punto de inicio y el destino
  Future<void> _drawRoute() async {
    try {
      final polylinePoints = PolylinePoints();
      final PolylineRequest request = PolylineRequest(
        origin: PointLatLng(widget.startPoint.latitude, widget.startPoint.longitude),
        destination: PointLatLng(widget.destinationPoint.latitude, widget.destinationPoint.longitude),
        mode: TravelMode.driving,
      );

      final PolylineResult result =
          await polylinePoints.getRouteBetweenCoordinates(request: request);

      if (result.points.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          _polylines.add(Polyline(
            polylineId: const PolylineId("route"),
            points: result.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No se pudo trazar la ruta.")),
          );
        }
      }
    } catch (e) {
      print("Error al trazar la ruta: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ocurrió un error al trazar la ruta."),
          ),
        );
      }
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
          zoom: 12.0,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
