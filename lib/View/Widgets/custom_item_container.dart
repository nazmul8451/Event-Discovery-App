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
                  ?   Color(0xFFCC18CA).withOpacity(0.15)
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + Category + Bookmark + Price
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      event.image,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Category Tag
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                        Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB026FF),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ),
                    ),
  
                    // Bookmark Button
                    Positioned(
                      top: 3.h,
                      right: 3.w,
                      child: IconButton(
                        onPressed: () {
                          savedProvider.toggleSave(event);
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? Colors.purple : Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
    ],
  ),
),

                  // Price Tag
                  if (event.price.isNotEmpty)
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D9FF),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          event.price,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Details Section
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Date
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/calender_icon.png',
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          event.date,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Location + Rating
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/location_icon.png',
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/star_icon.png',
                              height: 14.h,
                              width: 14.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              event.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
