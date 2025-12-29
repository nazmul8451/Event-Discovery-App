import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Controller/map_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/details_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapCtrl;
  Offset? _overlayPosition;
  String? _lastSelectedEventId;
  String _selectedCategory = "Vibe"; // Default as per design

  @override
  void initState() {
    super.initState();
    mapCtrl = MapController();
    mapCtrl.addListener(_updateUI);
    mapCtrl.init();
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    mapCtrl.removeListener(_updateUI);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (mapCtrl.selectedEvent != null && mapCtrl.selectedEvent!.id != _lastSelectedEventId) {
      _lastSelectedEventId = mapCtrl.selectedEvent!.id;
      _overlayPosition = null; // Force recalculation for new event
    }

    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: const Color(0xFF030303),
      body: Stack(
        children: [
          // --- Full Screen Map Area ---
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              // Trigger style update if map is already created
              mapCtrl.applyMapStyle(themeProvider.isDarkMode);

              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.8103, 90.4125),
                  zoom: 15,
                ),
                markers: mapCtrl.markers,
                polylines: mapCtrl.polylines,
                onMapCreated: (controller) {
                  mapCtrl.setMapController(controller);
                  mapCtrl.applyMapStyle(themeProvider.isDarkMode);
                  if (mapCtrl.currentPosition != null) {
                    mapCtrl.moveToCurrentLocation();
                  }
                },
                onCameraMove: (position) {
                  _updateOverlayPosition();
                },
                onTap: (_) {
                  mapCtrl.clearSelectedEvent();
                  setState(() {
                    _overlayPosition = null;
                  });
                },
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
              );
            },
          ),

          // --- Top Overlays (Header, Tabs, Filters) ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Custom Header ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: const Color(0xFFB026FF), size: 30.sp),
                      SizedBox(width: 15.w),
                      Text(
                        'G A T H E R I N G',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4.w,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // --- Tabs Section ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                  _buildTab("Music", _selectedCategory == "Music", isDark),
                  SizedBox(width: 30.w),
                  _buildTab("Vibe", _selectedCategory == "Vibe", isDark),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // --- Filter Chips ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.w),
                  child: Row(
                    children: [
                      _buildFilterChip("Chill lounge", isDark),
                      _buildFilterChip("High energy", isDark),
                      _buildFilterChip("Dancing", isDark),
                      _buildFilterChip("Brewery", isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Custom Info Card Above Marker ---
          if (mapCtrl.selectedEvent != null && _overlayPosition != null)
            _buildEventInfoOverlay(context, mapCtrl.selectedEvent!, context.read<ThemeProvider>()),

          // --- Map Tool Buttons (Zoom / Location) ---
          Positioned(
            bottom: 160.h, // Increased to avoid bottom bar
            right: 20.w,
            child: Column(
              children: [
                _buildMapToolButton(Icons.add, mapCtrl.zoomIn),
                SizedBox(height: 10.h),
                _buildMapToolButton(Icons.remove, mapCtrl.zoomOut),
                SizedBox(height: 10.h),
                _buildMapToolButton(Icons.my_location, mapCtrl.moveToCurrentLocation),
              ],
            ),
          ),

          // --- Bottom "Vide" Panel ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: const Color(0xFF030303),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.list, color: Colors.grey, size: 24.sp),
                  Text(
                    "Vide",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 24.sp),
                ],
              ),
            ),
          ),

          if (mapCtrl.isLoading || mapCtrl.eventsLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xFFB026FF))),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected 
                  ? (isDark ? Colors.white : Colors.black) 
                  : Colors.grey,
              fontSize: 18.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 5.h),
              height: 3.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5400),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5), // Off-white in light mode
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.grey : Colors.black87,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMapToolButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Future<void> _updateOverlayPosition() async {
    if (mapCtrl.selectedEvent == null || mapCtrl.mapController == null) return;

    final lat = (mapCtrl.selectedEvent!.location?.coordinates?[1] as num?)?.toDouble() ?? 0;
    final lng = (mapCtrl.selectedEvent!.location?.coordinates?[0] as num?)?.toDouble() ?? 0;

    final ScreenCoordinate screenCoordinate = await mapCtrl.mapController!.getScreenCoordinate(
      LatLng(lat, lng),
    );

    if (mounted) {
      setState(() {
        _overlayPosition = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
      });
    }
  }

  Widget _buildEventInfoOverlay(BuildContext context, EventData event, ThemeProvider themeProvider) {
    // Trigger update if position is null
    if (_overlayPosition == null) {
      _updateOverlayPosition();
      return const SizedBox.shrink();
    }

    final cardWidth = 220.w;

    return Positioned(
      left: _overlayPosition!.dx - (cardWidth / 2),
      top: _overlayPosition!.dy - 120.h, // Positioned above the marker
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailsScreen.name,
            arguments: event.id,
          );
        },
        child: Container(
          width: cardWidth,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title ?? 'Noir Lounge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.star, color: const Color(0xFFFF5400), size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    "4.0 Open",
                    style: TextStyle(
                      color: const Color(0xFFFF5400),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      "Not Cover",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
