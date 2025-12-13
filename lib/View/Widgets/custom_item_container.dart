import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Custom_item_container extends StatelessWidget {
  final EventData? event; // nullable korlam, data nai tahole shimmer

  Custom_item_container({super.key, this.event});



  @override
  Widget build(BuildContext context) {
    return Consumer<SavedEventController>(
      builder: (context, savedProvider, child) {
        final bool isLoading = event == null;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              width: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFCC18CA).withOpacity(0.15)
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + Overlay Tags Section
              Consumer<ThemeProvider>(
                builder:(context,controller,child)=> Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.r),
                        ),
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 150.h,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              )
                            : Image.network(
                                (event?.images != null &&
                                        event!.images!.isNotEmpty)
                                    ? "${Urls.baseUrl}${event!.images!.first}"
                                    : "assets/images/personLocation.jpg",
                                height: 150.h,
                                width: double.infinity,
                                fit: BoxFit.cover,

                              ),
                      ),
                
                      // Category Tag
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 20.h,
                                  width: 60.w,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB026FF),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Text(
                                  "${event!.category}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp.clamp(10, 12),
                                  ),
                                ),
                              ),
                      ),
                
                      // Price Tag
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 20.h,
                                  width: 40.w,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00D9FF),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Text(
                                  '${event!.ticketPrice}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp.clamp(10, 12),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Details Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 16.h,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "${event!.title}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp.clamp(12, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      SizedBox(height: 8.h),

                      // Date
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 12.h,
                                width: 80.w,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              children: [
                                Image.asset(
                                  'assets/images/calender_icon.png',
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    "${event!.ticketPrice}",
                                    style: TextStyle(
                                      fontSize: 9.sp.clamp(9, 10),
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 6.h),

                      // Location
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 12.h,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon.png',
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    "${event!.location}",
                                    style: TextStyle(
                                      fontSize: 9.sp.clamp(9, 10),
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
