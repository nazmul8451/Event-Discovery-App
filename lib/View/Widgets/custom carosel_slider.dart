import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({super.key});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  final List<String> images = [
    "assets/images/home_img1.png",
    "assets/images/home_img1.png",
    "assets/images/home_img1.png",
    "assets/images/home_img1.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Carousel Slider
        Column(
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        image: DecorationImage(
                          image: AssetImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200.h,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeFactor: 0.3,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;

                      });
                    },
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  int index = entry.key;
                  bool isActive = _currentIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.h,
                    width: isActive ? 20.w : 8.w,
                    // সিলেক্টেড ডট লম্বা
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFB026FF)
                          : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFFB026FF).withOpacity(0.6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        // Beautiful Dot Indicator (নিচে)
        // তোমার Stack এর মধ্যে শুধু এই Positioned টা রাখো (ডটের জায়গায়)
      ],
    );
  }
}
