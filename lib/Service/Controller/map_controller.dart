import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:geolocator/geolocator.dart';

class MapController with ChangeNotifier {
  // লোডিং স্টেট
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _eventsLoading = true;
  bool get eventsLoading => _eventsLoading;

  // কারেন্ট ইউজার লোকেশন
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // মার্কার লিস্ট
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // কাস্টম ইভেন্ট আইকন
  BitmapDescriptor? _eventIcon;
  BitmapDescriptor? get eventIcon => _eventIcon;

  // ইভেন্ট লিস্ট
  List<EventData> _events = [];
  List<EventData> get events => _events;

  // ম্যাপ কন্ট্রোলার (যদি দরকার হয়)
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  // init ফাংশন (MapPage এর initState থেকে কল করবে)
  Future<void> init() async {
    await _loadEventIcon();
    await _getCurrentLocation();
    await fetchAndAddEvents();
  }

  // কাস্টম আইকন লোড
Future<void> _loadEventIcon() async {
  try {
    _eventIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),  // ছোট সাইজ দাও
      'assets/images/event_marker.png',              // নতুন পাথ
    );
    debugPrint("কাস্টম আইকন সাকসেস: event_marker.png");
  } catch (e) {
    debugPrint("আইকন লোড ফেল: $e");
    _eventIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }
  notifyListeners();
}
  // কারেন্ট লোকেশন নেয়া
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      // কারেন্ট লোকেশন মার্কার যোগ করা
      _markers.removeWhere((m) => m.markerId.value == 'current_location');
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'আমার অবস্থান'),
        ),
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }
Future<void> fetchAndAddEvents() async {
  _eventsLoading = true;
  notifyListeners();

  // তোমার Urls ক্লাস থেকে URL নেয়া
  final response = await NetworkCaller.getRequest(
    url: Urls.getAllEvent,  
    requireAuth: true,     
  );

  if (response.isSuccess && response.statusCode == 200 && response.body != null) {
    final model = GetAllEventModel.fromJson(response.body!);
    _events = model.data?.data ?? [];

    debugPrint("Event Get: ${_events.length} Total");

    _markers.removeWhere((m) => m.markerId.value.startsWith('event_'));

    int added = 0;
    for (var event in _events) {
      // lat/long  (coordinates [lng, lat] )
      final lat = (event.location?.coordinates?[1] as num?)?.toDouble() ?? 0.0;
      final lng = (event.location?.coordinates?[0] as num?)?.toDouble() ?? 0.0;

      debugPrint("Event: ${event.title} | lat: $lat, lng: $lng");

      if (lat == 0.0 || lng == 0.0) {
        continue;
      }

      _markers.add(
        Marker(
          markerId: MarkerId('event_${event.id ?? event.iV ?? 'unknown'}'),
          position: LatLng(lat, lng),
          icon: _eventIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: event.title ?? 'Event',
          ),
          // onTap যদি দরকার হয় তাহলে এখানে রাখতে পারো বা MapPage থেকে হ্যান্ডেল করো
        ),
      );
      added++;
    }

    debugPrint("মার্কার যোগ হয়েছে: $added টি");
  } else {
    debugPrint("ইভেন্ট লোড ফেল হয়েছে: ${response.errorMessage}");
  }

  _eventsLoading = false;
  _isLoading = false;
  notifyListeners();
}

  // ম্যাপ কন্ট্রোলার সেট করা (onMapCreated থেকে)
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // ম্যাপকে কারেন্ট লোকেশনে মুভ করা
  Future<void> moveToCurrentLocation() async {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  // ম্যাপকে সব ইভেন্ট দেখানোর জন্য ফিট করা (অপশনাল)
  Future<void> fitAllEvents() async {
    if (_markers.isEmpty || _mapController == null) return;

    // সিম্পল উপায়: প্রথম ইভেন্টে মুভ (পুরোপুরি bounds করতে LatLngBounds লাগবে)
    final firstEvent = _markers.firstWhere(
      (m) => m.markerId.value.startsWith('event_'),
      orElse: () => _markers.first,
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLng(firstEvent.position),
    );
  }

  // লোডিং রিসেট বা রিফ্রেশ
  void resetLoading() {
    _isLoading = true;
    notifyListeners();
  }
}