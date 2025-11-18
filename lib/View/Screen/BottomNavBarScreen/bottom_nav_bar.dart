import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);
  static const String name = '/bottom-navbar-screen';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Center(child: Text('Home Page')),
    Center(child: Text('Map Page')),
    Center(child: Text('Saved Page')),
    Center(child: Text('Chat Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            items: [
              _navItem('assets/images/home_icon.png', 'Home', 0),
              _navItem('assets/images/map_icon.png', 'Map', 1),
              _navItem('assets/images/saved_icon.png', 'Saved', 2),
              _navItem('assets/images/chat_icon.png', 'Chat', 3),
              _navItem('assets/images/profile_icon.png', 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(String iconPath, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final Color primary = Theme.of(context).primaryColor;

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