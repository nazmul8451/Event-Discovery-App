import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';



class MapController with ChangeNotifier {
  /// ================= MAP + ROUTE =================
  late PolylinePoints _polylinePoints;
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;

  Set<Polyline> get polylines =>
      _routePolyline != null ? {_routePolyline!} : {};

  /// ================= STATE =================
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _eventsLoading = true;
  bool get eventsLoading => _eventsLoading;

  /// ================= LOCATION =================
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  /// ================= MAP CONTROLLER =================
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  /// ================= MARKERS =================
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  BitmapDescriptor? _eventIcon;

  /// ================= EVENTS =================
  List<EventData> _events = [];
  List<EventData> get events => _events;

  EventData? _selectedEvent;
  EventData? get selectedEvent => _selectedEvent;

  /// ================= INIT =================
  Future<void> init() async {
    _polylinePoints = PolylinePoints(
      apiKey:
          'pk_test_51RcvK8GdOsJASBMC9aDK1onP8kTVwAxve4385Mr09r2Edd1fxcbSWD1y5DCclahZ7MHa0hf1eBnsnq16bWavPRY400W2WfumAa',
    );
    await _loadEventIcon();
    await getCurrentLocation();
    await fetchAndAddEvents();
  }

  /// ================= ZOOM =================
  Future<void> zoomIn() async {
    if (_mapController == null) return;
    final zoom = await _mapController!.getZoomLevel();
    _mapController!.animateCamera(CameraUpdate.zoomTo(zoom + 1));
  }

  Future<void> zoomOut() async {
    if (_mapController == null) return;
    final zoom = await _mapController!.getZoomLevel();
    _mapController!.animateCamera(CameraUpdate.zoomTo(zoom - 1));
  }

  /// ================= ICON =================
  Future<void> _loadEventIcon() async {
    try {
      _eventIcon = await _createCustomMarkerBitmap(80, 110);
    } catch (_) {
      _eventIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(int size, int height) async {
    // Increase canvas size to accommodate glow
    final int canvasWidth = (size * 1.5).toInt();
    final int canvasHeight = (height * 1.2).toInt();
    
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..isAntiAlias = true;

    final double centerX = canvasWidth / 2;
    final double centerY = canvasWidth / 2;

    // Draw a soft purple glow behind the pin
    final glowPaint = Paint()
      ..color = const Color(0xFFB026FF).withOpacity(0.4)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 15);
    canvas.drawCircle(Offset(centerX, centerY), size / 2, glowPaint);

    // Draw the main pin shape
    final Path path = Path();
    path.moveTo(centerX, canvasHeight.toDouble());
    path.quadraticBezierTo(centerX - size / 2, centerY + size / 2, centerX - size / 2, centerY);
    path.arcToPoint(Offset(centerX + size / 2, centerY), radius: Radius.circular(size / 2));
    path.quadraticBezierTo(centerX + size / 2, centerY + size / 2, centerX, canvasHeight.toDouble());
    path.close();

    // Create gradient
    paint.shader = ui.Gradient.linear(
      Offset(centerX, canvasHeight.toDouble()),
      Offset(centerX, 0),
      [
        const Color(0xFFB026FF), 
        const Color(0xFFFF5400), 
      ],
    );
    canvas.drawPath(path, paint);

    // Draw inner circle
    paint.shader = null;
    paint.color = Colors.black.withOpacity(0.4);
    canvas.drawCircle(Offset(centerX, centerY), size / 4, paint);

    paint.color = Colors.black;
    canvas.drawCircle(Offset(centerX, centerY), size / 6, paint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(canvasWidth, canvasHeight);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }



  /// ================= LOCATION =================
  Future<void> getCurrentLocation() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _markers.removeWhere((m) => m.markerId.value == 'current_location');

      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  Future<void> moveToCurrentLocation() async {
    if (_currentPosition == null || _mapController == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  /// ================= EVENTS =================
  Future<void> fetchAndAddEvents() async {
    _eventsLoading = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      url: Urls.getAllEvent,
      requireAuth: true,
    );

    if (response.isSuccess && response.body != null) {
      final model = GetAllEventModel.fromJson(response.body!);
      _events = model.data?.data ?? [];

      _markers.removeWhere((m) => m.markerId.value.startsWith('event_'));

      for (var event in _events) {
        final lat = (event.location?.coordinates?[1] as num?)?.toDouble() ?? 0;
        final lng = (event.location?.coordinates?[0] as num?)?.toDouble() ?? 0;

        if (lat == 0 || lng == 0) continue;

        _markers.add(
          Marker(
            markerId: MarkerId('event_${event.id ?? event.iV}'),
            position: LatLng(lat, lng),
            icon: _eventIcon!,
            // infoWindow: InfoWindow(title: event.title), // Remove default info window
            onTap: () {
              _selectedEvent = event;
              notifyListeners();
              // Center camera on marker
              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(LatLng(lat, lng)),
                );
              }
              showRouteToEvent(LatLng(lat, lng));
            },

          ),
        );
      }
    }

    _eventsLoading = false;
    _isLoading = false;
    notifyListeners();
  }

  /// ================= ROUTE =================
  void clearRoute() {
    _polylineCoordinates.clear();
    _routePolyline = null;
    notifyListeners();
  }

Future<void> showRouteToEvent(LatLng eventLatLng) async {
  if (_currentPosition == null || _mapController == null) return;

  clearRoute();

  final polylinePoints = PolylinePoints(apiKey: 'pk_test_51RcvK8GdOsJASBMC9aDK1onP8kTVwAxve4385Mr09r2Edd1fxcbSWD1y5DCclahZ7MHa0hf1eBnsnq16bWavPRY400W2WfumAa');

  try {
    // Use PolylineRequest instead of RoutesApiRequest
    final request = PolylineRequest(
      origin: PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      destination: PointLatLng(eventLatLng.latitude, eventLatLng.longitude), mode: TravelMode.driving,
    );

    final response = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
    );

    if (response.points.isNotEmpty) {
      _polylineCoordinates = response.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      _routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: _polylineCoordinates,
      );

      notifyListeners();
    }
  } catch (e) {
    debugPrint('Route error: $e');
  }
}

  /// ================= MAP CONTROLLER =================
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> applyMapStyle(bool isDarkMode) async {
    if (_mapController == null) return;
    try {
      final String stylePath = isDarkMode
          ? 'assets/map_dark_style.json'
          : 'assets/map_style.json';
      final String style = await rootBundle.loadString(stylePath);
      await _mapController!.setMapStyle(style);
      print("🗺️ Map style applied: ${isDarkMode ? 'Dark' : 'Light'}");
    } catch (e) {
      debugPrint('Error applying map style: $e');
    }
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    clearRoute();
    notifyListeners();
  }
}
