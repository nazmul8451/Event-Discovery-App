import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/home_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/profile_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/saved_page.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);
  static const String name = '/bottom-navbar-screen';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Map Page')),
    const SavedPage(),
    ChatPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80.h + MediaQuery.of(context).padding.bottom,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          height: 60.h,
          margin: EdgeInsets.only(
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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

              return Consumer<ThemeProvider>(
                builder: (context, controller, child) => GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: 70.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: isSelected
                        ? BoxDecoration(
                      color: const Color(0xFFCC18CA).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24.r),
                    )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          icons[index],
                          width: 28.w,
                          height: 28.h,
                          color: isSelected
                              ? const Color(0xFFB026FF)
                              : controller.isDarkMode
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isSelected
                                ? const Color(0xFFB026FF)
                                : controller.isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(String iconPath, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        width: 70,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: isSelected
            ? BoxDecoration(
           color: Color(0xFFCC18CA).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ?Color(0xFFB026FF) : Colors.grey.shade400,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Color(0xFFB026FF) : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}