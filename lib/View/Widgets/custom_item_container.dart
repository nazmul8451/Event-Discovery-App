import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Custom_item_container extends StatelessWidget {
  final EventData event;
  final VoidCallback? onTap;

  const Custom_item_container({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final String imageUrl = (event.images != null && event.images!.isNotEmpty)
        ? "${Urls.baseUrl}${event.images!.first}"
        : "assets/images/personLocation.jpg";

    final String category = event.category ?? 'Event';
    final String price = event.ticketPrice == 0 ? "Free" : "\$${event.ticketPrice}";
    final String title = event.title ?? "Untitled Event";
    final String dateStr = event.startDate != null 
        ? "${event.startDate!.day}/${event.startDate!.month} • ${event.startTime ?? ''}" 
        : "Date TBA";
    final String location = event.address ?? "Location TBA";
    const double rating = 4.8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF130124) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            width: 1.w,
            color: const Color(0xFFCC18CA),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 12,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(19.r)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),

                  // Category Chip
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC18CA),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Bookmark Button
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Consumer<SavedEventController>(
                      builder: (context, controller, _) {
                        final isSaved = controller.isSaved(event);
                        return GestureDetector(
                          onTap: () async {
                            await controller.toggleSave(event);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: const Color(0xFFFF006E),
                              size: 18.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Price Chip
                  Positioned(
                    bottom: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00F0FF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        price,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.star_border, size: 14.sp, color: Colors.white),
                      SizedBox(width: 2.w),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
