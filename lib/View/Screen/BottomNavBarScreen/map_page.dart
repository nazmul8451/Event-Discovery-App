import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapCtrl;

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/Vector.png',
            height: 15.h,
            width: 15.w,
          ),
        ),
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'GATHERING',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125),
              zoom: 15,
            ),
            markers: mapCtrl.markers,
            polylines: mapCtrl.polylines,
            onMapCreated: (controller) {
              mapCtrl.setMapController(controller);
              if (mapCtrl.currentPosition != null) {
                mapCtrl.moveToCurrentLocation();
              }
            },
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),

          Positioned(
            bottom: 100.h,
            right: 20.w,
            child: FloatingActionButton(
              heroTag: 'myLocation',
              onPressed: () async {
                await mapCtrl.moveToCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          Positioned(
            bottom: 170.h,
            right: 20.w,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoomIn',
                  onPressed: mapCtrl.zoomIn,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                SizedBox(height: 8.h),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoomOut',
                  onPressed: mapCtrl.zoomOut,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black),
                ),
              ],
            ),
          ),

          if (mapCtrl.isLoading || mapCtrl.eventsLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
