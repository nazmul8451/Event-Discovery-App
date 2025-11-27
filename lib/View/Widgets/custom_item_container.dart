import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:gathering_app/ViewModel/event_cartModel.dart';
import 'package:provider/provider.dart';

class Custom_item_container extends StatelessWidget {
  final EventCartmodel event;

  const Custom_item_container({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedEventController>(
      builder: (context, savedProvider, child) {
        final bool isSaved = savedProvider.isSaved(event);

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
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                      child: Image.asset(
                        event.image,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                
                    // Category Tag
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB026FF),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(color: Colors.white, fontSize: 10.sp.clamp(10, 12)),
                        ),
                      ),
                    ),
                
                    // Bookmark Button
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => savedProvider.toggleSave(event),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? Colors.purple : Colors.white,
                          size: 20.sp.clamp(20, 22),
                        ),
                      ),
                    ),
                
                    // Price Tag
                    if (event.price.isNotEmpty)
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D9FF),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Text(
                            event.price,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:  10.sp.clamp(10, 12)
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Details Section (এটা আগের মতোই আছে)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp.clamp(12, 14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Date
                      Row(
                        children: [
                          Image.asset('assets/images/calender_icon.png', height: 16.h, width: 16.w),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              event.date,
                              style: TextStyle(fontSize: 9.sp.clamp(9, 10), color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                
                      // Location + Rating
                      Row(
                        children: [
                          Image.asset('assets/images/location_icon.png', height: 16.h, width: 16.w),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              event.location,
                              style: TextStyle(fontSize: 9.sp.clamp(9, 10), color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/star_icon.png', height: 14.h, width: 14.w),
                              SizedBox(width: 4.w),
                              Text(
                                event.rating.toStringAsFixed(1),
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
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