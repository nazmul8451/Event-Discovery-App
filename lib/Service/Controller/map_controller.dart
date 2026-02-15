import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:gathering_app/Utils/app_utils.dart';

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

  bool _isRouting = false;
  bool get isRouting => _isRouting;

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

  String? _distance;
  String? get distance => _distance;

  String? _duration;
  String? get duration => _duration;

  /// ================= INIT =================
  Future<void> init() async {
    _polylinePoints = PolylinePoints(
      apiKey: 'AIzaSyDvuwAjadUqjxuBqNbTnZ5WhZ3HrD3ODGk',
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

  Future<BitmapDescriptor> _createCustomMarkerBitmap(
    int size,
    int height,
  ) async {
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
    path.quadraticBezierTo(
      centerX - size / 2,
      centerY + size / 2,
      centerX - size / 2,
      centerY,
    );
    path.arcToPoint(
      Offset(centerX + size / 2, centerY),
      radius: Radius.circular(size / 2),
    );
    path.quadraticBezierTo(
      centerX + size / 2,
      centerY + size / 2,
      centerX,
      canvasHeight.toDouble(),
    );
    path.close();

    // Create gradient
    paint.shader = ui.Gradient.linear(
      Offset(centerX, canvasHeight.toDouble()),
      Offset(centerX, 0),
      [const Color(0xFFB026FF), const Color(0xFFFF5400)],
    );
    canvas.drawPath(path, paint);

    // Draw inner circle
    paint.shader = null;
    paint.color = Colors.black.withOpacity(0.4);
    canvas.drawCircle(Offset(centerX, centerY), size / 4, paint);

    paint.color = Colors.black;
    canvas.drawCircle(Offset(centerX, centerY), size / 6, paint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      canvasWidth,
      canvasHeight,
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
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
              // showRouteToEvent will handle specialized camera movement
              showRouteToEvent(LatLng(lat, lng));
              _calculateDistance(LatLng(lat, lng));
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
    if (_currentPosition == null) {
      debugPrint('📍 Current position is null, attempting to get location...');
      await getCurrentLocation();
    }

    // if (_currentPosition == null) {
    //   _showError('Please enable location services to view the route');
    //   return;
    // }

    if (_mapController == null) {
      debugPrint('🗺️ Map controller is not initialized yet');
      return;
    }

    _isRouting = true;
    notifyListeners();
    debugPrint(
      '🌉 Starting showRouteToEvent to ${eventLatLng.latitude}, ${eventLatLng.longitude}',
    );

    clearRoute();

    final polylinePoints = PolylinePoints(
      apiKey: 'AIzaSyDvuwAjadUqjxuBqNbTnZ5WhZ3HrD3ODGk',
    );

    try {
      // Use PolylineRequest instead of RoutesApiRequest
      final request = PolylineRequest(
        origin: PointLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        destination: PointLatLng(eventLatLng.latitude, eventLatLng.longitude),
        mode: TravelMode.driving,
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
          color: const Color(0xFF4285F4), // Google Maps Blue
          width: 5,
          points: _polylineCoordinates,
        );

        // Fetch Distance and Duration from Directions API directly for accuracy
        await _fetchRouteInfo(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          eventLatLng.latitude,
          eventLatLng.longitude,
        );

        notifyListeners();
        _fitRouteBounds(eventLatLng);
        debugPrint('✅ Route polyline and info updated successfully');
      } else {
        debugPrint('❌ Directions API Failure:');
        debugPrint('   Status: ${response.status}');
        debugPrint('   Error Message: ${response.errorMessage}');
        // _showError(
        //   response.errorMessage ?? 'No road path found to this location',
        // );
      }
    } catch (e) {
      debugPrint('Route error in showRouteToEvent: $e');
      // _showError('Error calculating route path');
    } finally {
      _isRouting = false;
      notifyListeners();
    }
  }

  Future<void> _fetchRouteInfo(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
  ) async {
    const apiKey = 'AIzaSyDvuwAjadUqjxuBqNbTnZ5WhZ3HrD3ODGk';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final leg = data['routes'][0]['legs'][0];
          _distance = leg['distance']['text'];
          _duration = leg['duration']['text'];
          debugPrint('🚗 Route Info Fetched: $_duration, $_distance');
          notifyListeners();
        } else {
          debugPrint('⚠️ Directions API returned no routes');
        }
      } else {
        debugPrint(
          '❌ Directions API Error: ${response.statusCode} - ${response.body}',
        );
        // _showError(
        //   'Failed to fetch travel info (Error: ${response.statusCode})',
        // );
      }
    } catch (e) {
      debugPrint('FetchRouteInfo error: $e');
      // _showError('Network error while fetching route');
    }
  }

  // void _showError(String message) {
  //   debugPrint('📢 Map Error: $message');
  //   final context = AppUtils.navigatorKey.currentContext;
  //   if (context != null) {
  //     // Per user request: suppress persistent API authorization/denial errors
  //     if (message.contains('not authorized') ||
  //         message.contains('API key') ||
  //         message.contains('REQUEST_DENIED')) {
  //       debugPrint('🚫 Suppressing API error snackbar per user request');
  //       return;
  //     }

  //     String userFriendlyMessage = message;

  //     showCustomSnackBar(
  //       context: context,
  //       message: userFriendlyMessage,
  //       isError: true,
  //     );
  //   }
  // }

  /// ================= MAP CONTROLLER =================
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void _fitRouteBounds(LatLng eventLatLng) {
    if (_mapController == null || _currentPosition == null) return;

    final LatLng userLatLng = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    LatLngBounds bounds;
    if (userLatLng.latitude > eventLatLng.latitude &&
        userLatLng.longitude > eventLatLng.longitude) {
      bounds = LatLngBounds(southwest: eventLatLng, northeast: userLatLng);
    } else if (userLatLng.longitude > eventLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(userLatLng.latitude, eventLatLng.longitude),
        northeast: LatLng(eventLatLng.latitude, userLatLng.longitude),
      );
    } else if (userLatLng.latitude > eventLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(eventLatLng.latitude, userLatLng.longitude),
        northeast: LatLng(userLatLng.latitude, eventLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: userLatLng, northeast: eventLatLng);
    }

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
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

  void _calculateDistance(LatLng eventLatLng) {
    if (_currentPosition == null) return;

    double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      eventLatLng.latitude,
      eventLatLng.longitude,
    );

    if (distanceInMeters >= 1000) {
      _distance = "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
    } else {
      _distance = "${distanceInMeters.round()} m";
    }
    notifyListeners();
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    _distance = null;
    _duration = null;
    clearRoute();
    notifyListeners();
  }
}
