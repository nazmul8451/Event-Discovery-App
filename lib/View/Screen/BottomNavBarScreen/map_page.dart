import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Define _initialPosition here
  static const LatLng _initialPosition = LatLng(37.7749, -122.4194); // Example: San Francisco

  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    // Load the map style from the JSON file
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
    _addMarkers();
  }

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(37.7749, -122.4194),
          infoWindow: InfoWindow(
            title: 'Noir Lounge',
            snippet: '★ 4.0 Open',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('marker_2'),
          position: LatLng(37.7849, -122.4294),
          infoWindow: InfoWindow(
            title: 'Another Lounge',
            snippet: '★ 4.5 Open',
          ),
        ),
      );
    });
  }

  // This function is called when the map is created
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Set the map style if it's loaded
    if (_mapStyle != null) {
      _mapController.setMapStyle(_mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/Vector.png',
            height: 15.h,
            width: 15.w,
          ),
        ),
        titleSpacing: 0, // This brings the title closer to the leading widget
        title: Align(alignment: Alignment.bottomLeft, child: Text('GATHERING')),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        markers: _markers, // Add the markers to the map
        onMapCreated: _onMapCreated, // Add the onMapCreated callback
      ),
    );
  }
}