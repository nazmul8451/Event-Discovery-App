import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/home_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/map_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/profile_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/saved_page.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'chat_page.dart';

class BottomNavBarScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavBarScreen({Key? key, this.initialIndex = 0}) : super(key: key);
  static const String name = '/bottom-navbar-screen';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const SavedPage(),
    ChatPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Container(
            height: 72.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final bool isSelected = _selectedIndex == index;

                final List<String> icons = [
                  'assets/images/home_icon.png',
                  'assets/images/map_icon.png',
                  'assets/images/saved_icon.png',
                  'assets/images/chat_icon.png',
                  'assets/images/profile_icon.png',
                ];

                final List<String> labels = ['Home', 'Map', 'Saved', 'Chat', 'Profile'];

                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 75.w, 
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFCC18CA).withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          icons[index],
                          width: 26.w,
                          height: 26.h,
                          color: isSelected
                              ? const Color(0xFFB026FF)
                              : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFB026FF)
                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}