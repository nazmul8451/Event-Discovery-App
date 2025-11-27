import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/details_screen.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/notification_screen.dart';
import 'package:gathering_app/View/Widgets/serch_textfield.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:gathering_app/ViewModel/event_cartModel.dart';
import 'package:gathering_app/View/Widgets/custom_item_container.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // <-- Ei line add kor

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

  // Refresh Controller — ei ta add korlam
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

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
      title: "Paradise Festival",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "2",
      title: "Festival",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "3",
      title: "Electric Paradise",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "4",
      title: "Roma",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "5",
      title: "Event",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),
    EventCartmodel(
      id: "6",
      title: "Electric Paradise Festival",
      image: "assets/images/home_img1.png",
      category: "Music",
      price: "\$50",
      date: "Nov 15 • 8:00 PM",
      location: "Downtown Arena • 2.3 km",
      rating: 3.6,
    ),

    // baki gulo same...
  ];

  final List<Map<String, dynamic>> categories = [
    {"label": "All", "icon": Icons.auto_awesome},
    {"label": "Nightlife", "icon": Icons.nights_stay_outlined},
    {"label": "Music", "icon": Icons.music_note_outlined},
    {"label": "Concerts", "icon": Icons.mic_none_outlined},
    {"label": "Food & Drinks", "icon": Icons.local_drink_outlined},
  ];

  // Pull to Refresh Function
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // ekhane real API call → events = await getEvents();

    if (mounted) {
      setState(() {
        // data reload hobe
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
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
                    constraints: const BoxConstraints(
                      minHeight: 18,
                      minWidth: 18,
                    ),
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
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: const Color(0xFFB026FF), // tor brand color
          idleIcon: const Icon(
            Icons.auto_awesome,
            color: Color(0xFFB026FF),
            size: 20,
          ),
          complete: const Text(
            "Refreshed!",
            style: TextStyle(color: Color(0xFFB026FF)),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120.0),
            child: Column(
              children: [
                const SearchTextField(hintText: 'Search events, venues'),
                // Filter Chips
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
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
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // Featured Banners
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, DetailsScreen.name),
                        child: _buildFeaturedEvent(
                          "Kickback",
                          "TONIGHT: House Party",
                          ["Chill", "Social"],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, DetailsScreen.name),
                        child: _buildFeaturedEvent(
                          "Kickback",
                          "TONIGHT: House Party",
                          ["Chill", "Social"],
                        ),
                      ),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.w,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, DetailsScreen.name),
                        child: Custom_item_container(event: events[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                    size: 25.sp.clamp(25,26),
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
                    fontSize: 22.sp.clamp(22, 22),
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
                        fontSize: 12.sp.clamp(12, 16),
                      ),
                    ),
                    const Spacer(),
                    ...tags.map(
                      (tag) => Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: _buildTag(tag),
                      ),
                    ),
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp.clamp(13, 13),
          fontWeight: FontWeight.w600,
        ),
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
