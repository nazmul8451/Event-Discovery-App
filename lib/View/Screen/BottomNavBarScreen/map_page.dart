import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Controller/map_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/details_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gathering_app/Service/urls.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _localMapController;
  String? _lastSelectedEventId;
  String _selectedCategory = "Vibe"; // Default as per design

  @override
  void initState() {
    super.initState();
    context.read<MapController>().addListener(_updateUI);
  }

  void _updateUI() {
    if (!mounted) return;
    final mapCtrl = context.read<MapController>();

    if (mapCtrl.selectedEvent != null) {
      if (mapCtrl.selectedEvent!.id != _lastSelectedEventId) {
        _lastSelectedEventId = mapCtrl.selectedEvent!.id;
      }
    } else {
      _lastSelectedEventId = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    context.read<MapController>().removeListener(_updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapCtrl = context.watch<MapController>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: const Color(0xFF030303),
      body: Stack(
        children: [
          // --- Full Screen Map Area ---
          Consumer2<ThemeProvider, MapController>(
            builder: (context, themeProvider, mapCtrl, child) {
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
                  _localMapController = controller;
                  mapCtrl.setMapController(controller);
                  mapCtrl.applyMapStyle(themeProvider.isDarkMode);
                  if (mapCtrl.currentPosition != null) {
                    mapCtrl.moveToCurrentLocation();
                  }
                },
                onTap: (_) {
                  mapCtrl.clearSelectedEvent();
                  setState(() {
                    _lastSelectedEventId = null;
                  });
                },
                zoomControlsEnabled: false,
                myLocationEnabled: true, // Show user location dot properly
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: const Color(0xFFB026FF),
                        size: 30.sp,
                      ),
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

          // --- Custom Bottom Info Card ---
          if (mapCtrl.selectedEvent != null)
            _buildBottomEventCard(mapCtrl.selectedEvent!, mapCtrl),

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
                _buildMapToolButton(
                  Icons.my_location,
                  mapCtrl.moveToCurrentLocation,
                ),
              ],
            ),
          ),

          // --- Bottom "Vide" Panel ---
          if (mapCtrl.selectedEvent == null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF030303),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
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
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.grey,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ),

          if (mapCtrl.isLoading || mapCtrl.eventsLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFB026FF)),
            ),
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
        color: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F5), // Off-white in light mode
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
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

  Widget _buildBottomEventCard(EventData event, MapController mapCtrl) {
    return Positioned(
      bottom: 90.h, // Adjusted to sit above BottomNavigationBar
      left: 16.w,
      right: 16.w,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailsScreen.name, arguments: event.id);
        },
        child: Container(
          height: 220.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            image: DecorationImage(
              image: event.images != null && event.images!.isNotEmpty
                  ? NetworkImage("${Urls.baseUrl}${event.images!.first}")
                  : AssetImage('assets/images/container_img.png')
                        as ImageProvider,
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5400),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        event.title ?? "Event Title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.stars, color: Color(0xFFB026FF), size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      "Official Gathering Location",
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                    if (mapCtrl.distance != null) ...[
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        color: Colors.white60,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: mapCtrl.duration != null
                                  ? "${mapCtrl.duration} "
                                  : "",
                              style: TextStyle(
                                color: const Color(
                                  0xFF1DB954,
                                ), // Friendly Green
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "(${mapCtrl.distance})",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white60, size: 14.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        event.address ?? "Address not available",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            DetailsScreen.name,
                            arguments: event.id,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB026FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.near_me,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Check In",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: mapCtrl.isRouting
                            ? null
                            : () {
                                if (_localMapController != null) {
                                  mapCtrl.setMapController(
                                    _localMapController!,
                                  );
                                }
                                final lat =
                                    (event.location?.coordinates?[1] as num?)
                                        ?.toDouble() ??
                                    0;
                                final lng =
                                    (event.location?.coordinates?[0] as num?)
                                        ?.toDouble() ??
                                    0;
                                mapCtrl.showRouteToEvent(LatLng(lat, lng));
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (mapCtrl.isRouting)
                              SizedBox(
                                height: 16.sp,
                                width: 16.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else ...[
                              Icon(
                                Icons.near_me_outlined,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Get Direction${mapCtrl.duration != null ? ' (${mapCtrl.duration})' : ''}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
