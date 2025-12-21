import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:shimmer/shimmer.dart';
class Custom_item_container extends StatelessWidget {
  final EventData event; // null হবে না, সবসময় valid event পাস করবো

  const Custom_item_container({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
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
          // Image Section
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: CachedNetworkImage( 
                    imageUrl: (event.images != null && event.images!.isNotEmpty)
                        ? "${Urls.baseUrl}${event.images!.first}"
                        : "assets/images/personLocation.jpg",
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                // Category & Price Tag (আগের মতোই)
                // ... তোমার বাকি কোড
              ],
            ),
          ),

          // Details Section (title, date, location) - null safe করে নাও
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title ?? "Untitled Event",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Image.asset('assets/images/calender_icon.png', height: 16.h),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                        "${event.startDate?? "00"}", // ticketPrice না, date দেখাও
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Image.asset('assets/images/location_icon.png', height: 16.h),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          "${event.location ?? "Location TBA"}",
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
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
  }
}