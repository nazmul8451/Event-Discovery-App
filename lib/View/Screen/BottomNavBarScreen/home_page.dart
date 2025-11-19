import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/notification_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/serch_textfield.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:gathering_app/ViewModel/event_cartModel.dart';
import 'package:gathering_app/View/Widgets/custom_item_container.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String appBarTitle = 'Discover';
  final String appBarSubTitle = 'Find your next adventure';
  final String trendName = 'Trending Now';

  int selectedCategoryIndex = 0;

  // এখানে ডাটা লিস্ট রাখবো (API থেকে আসবে)
  List<EventCartmodel> events = [
    EventCartmodel(
      id: "0",
      title: "Electric Paradise Festival",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "1",
      title: "Electric",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),


  ];

  // ক্যাটাগরি লিস্ট (পরে API থেকে আনবে)
  final List<Map<String, dynamic>> categories = [
    {"label": "All", "icon": Icons.auto_awesome},
    {"label": "Nightlife", "icon": Icons.nights_stay_outlined},
    {"label": "Music", "icon": Icons.music_note_outlined},
    {"label": "Concerts", "icon": Icons.mic_none_outlined},
    {"label": "Food & Drinks", "icon": Icons.local_drink_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appBarTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                appBarSubTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NotificationScreen.name);
                  },
                  icon: const Icon(Icons.notifications_none),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF006E),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minHeight: 18, minWidth: 18),
                    child: const Text(
                      '5',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SearchTextField(hintText: 'Search events, venues'),
            // Filter Chips
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    var category = entry.value;
                    bool isSelected = selectedCategoryIndex == index;

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _buildCustomFilterChip(
                        label: category["label"],
                        icon: category["icon"],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                            // পরে এখানে API filter call করবে
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Featured Banners (দুইটা)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFeaturedEvent("Kickback", "TONIGHT: House Party", ["Chill", "Social"]),
                  SizedBox(height: 12.h),
                  _buildFeaturedEvent("Sunset Vibes", "Weekend Beach Party", ["Music", "Free"]),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Trending Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  trendName,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // GridView
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 7 / 9,
              ),
              itemBuilder: (context, index) {
                return Custom_item_container(event: events[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Featured Event Card
  Widget _buildFeaturedEvent(String title, String subtitle, List<String> tags) {
    return Container(
      height: 197.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/home_img1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Consumer<SavedEventController>(
              builder: (context, provider, child) {
                final isSaved = false; // পরে API থেকে চেক করবে
                return IconButton(
                  onPressed: () {},
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                );
              },
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
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16.sp,
                      ),
                    ),
                    const Spacer(),
                    ...tags.map((tag) => Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: _buildTag(tag),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCustomFilterChip({
    required String label,
    required IconData icon,
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
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}