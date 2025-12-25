import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Default initial position (will be replaced by current location)
  static const LatLng _initialPosition = LatLng(23.7819724, 90.4030421);

  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  String? _mapStyle;
  Position? _currentPosition;
  bool _cameraMoved = false; // Track if camera already moved to current location

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _checkLocationPermission();
    _addMarkers();
  }

  Future<void> _loadMapStyle() async {
    try {
      _mapStyle = await rootBundle.loadString('assets/map_style.json');
    } catch (e) {
      print("Error loading map style: $e");
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Location permissions are permanently denied, please enable in settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: Geolocator.openAppSettings,
          ),
        ),
      );
      return;
    }

    // Permissions granted, fetch current location
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;

        // Remove previous current location marker
        _markers.removeWhere((m) => m.markerId.value == 'current_location');

        // Add current location marker
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      });

      // Move camera only once
      if (!_cameraMoved) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16,
            ),
          ),
        );
        _cameraMoved = true;
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker_1'),
          position: const LatLng(37.7749, -122.4194),
          onTap: () {
            _showEventDetailsBottomSheet(
              'Noir Lounge',
              '★ 4.0 Open',
              'assets/images/home_img1.png',
            );
          },
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('marker_2'),
          position: const LatLng(37.7849, -122.4294),
          onTap: () {
            _showEventDetailsBottomSheet(
              'Another Lounge',
              '★ 4.5 Open',
              'assets/images/home_img1.png',
            );
          },
        ),
      );
    });
  }

  void _showEventDetailsBottomSheet(
      String title, String rating, String imagePath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      imagePath,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        height: 80.h,
                        width: 80.w,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5669FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: const Text(
                            "View Details",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
        titleSpacing: 0,
        title: Align(alignment: Alignment.bottomLeft, child: Text('GATHERING')),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 16,
            ),
            markers: _markers,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
