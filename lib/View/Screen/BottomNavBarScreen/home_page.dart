import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/serch_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String appBarTitle = 'Discover';
  final String appBarSubTitle = 'Find your next adventure';
  final String trendName = 'Trending Now';
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Column(
          children: [
            ListTile(
              title: Text(
                '${appBarTitle}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20.sp.clamp(20, 22),
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${appBarSubTitle}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF006E),
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minHeight: 18, maxWidth: 18),
                    child: Center(
                      child: Text(
                        '5',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchTextField(hintText: 'Search events,venues'),
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // All
                    _buildCustomFilterChip(
                      label: 'All',
                      icon: Icons.auto_awesome,
                      index: 0,
                      isSelected: selectedIndex == 0,
                      onTap: () => setState(() => selectedIndex = 0),
                    ),
                    SizedBox(width: 8.w),

                    // Nightlife
                    _buildCustomFilterChip(
                      label: 'Nightlife',
                      icon: Icons.nights_stay_outlined,
                      index: 1,
                      isSelected: selectedIndex == 1,
                      onTap: () => setState(() => selectedIndex = 1),
                    ),
                    SizedBox(width: 8.w),

                    // Music
                    _buildCustomFilterChip(
                      label: 'Music',
                      icon: Icons.music_note_outlined,
                      index: 2,
                      isSelected: selectedIndex == 2,
                      onTap: () => setState(() => selectedIndex = 2),
                    ),
                    SizedBox(width: 8.w),

                    // Concerts
                    _buildCustomFilterChip(
                      label: 'Concerts',
                      icon: Icons.mic_none_outlined,
                      index: 3,
                      isSelected: selectedIndex == 3,
                      onTap: () => setState(() => selectedIndex = 3),
                    ),
                    SizedBox(width: 8.w),

                    // Food & Drinks
                    _buildCustomFilterChip(
                      label: 'Food & Drinks',
                      icon: Icons.local_drink_outlined,
                      index: 4,
                      isSelected: selectedIndex == 4,
                      onTap: () => setState(() => selectedIndex = 4),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    height: 197.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_img1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kickback",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp.clamp(20, 30),
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 4.h),

                              Row(
                                children: [
                                  Text(
                                    "TONIGHT: House Party",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16.sp.clamp(16, 20),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  _buildTag("Chill"),
                                  SizedBox(width: 7.w),
                                  _buildTag("Social"),
                                  // আরো ট্যাগ চাইলে যোগ করতে পারো
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 197.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_img1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kickback",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp.clamp(20, 30),
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 4.h),

                              Row(
                                children: [
                                  Text(
                                    "TONIGHT: House Party",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16.sp.clamp(16, 20),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  _buildTag("Chill"),
                                  SizedBox(width: 7.w),
                                  _buildTag("Social"),
                                  // আরো ট্যাগ চাইলে যোগ করতে পারো
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${trendName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp.clamp(20, 22),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // GridView.builder(
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: 10,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //   ),
                  //   itemBuilder: (context,index){
                  //     return
                  //   },
                  // ),
                  Container(
                    height: 224.h,
                    width: 197.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        Align(
                          child: Container(
                            height: 160.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/home_img1.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ট্যাগ উইজেট (Chill, Social)
  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.r),
        // border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp.clamp(13, 15),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCustomFilterChip({
    required String label,
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB026FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp.clamp(14, 16),
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 14.sp.clamp(14, 16),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
