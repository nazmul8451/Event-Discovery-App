import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/create_event_screen.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/home_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/map_page.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/profile_page.dart';
import 'chat_page.dart';

import 'package:gathering_app/Service/Controller/chat_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/Service/Controller/bottom_nav_controller.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:provider/provider.dart';

class BottomNavBarScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavBarScreen({super.key, this.initialIndex = 0});
  static const String name = '/bottom-navbar-screen';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize if needed, but controller handles it.
    // Usually standard provider pattern doesn't need init here unless syncing widget param.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavController>().onItemTapped(widget.initialIndex);

      // Global Chat Initialization
      final auth = AuthController();
      if (auth.userId == null) {
        context
            .read<ProfileController>()
            .fetchProfile(forceRefresh: false)
            .then((_) {
              context.read<ChatController>().getChats();
              context.read<ChatController>().initChatListSocket();
            });
      } else {
        context.read<ChatController>().getChats();
        context.read<ChatController>().initChatListSocket();
      }
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    MapPage(),
    CreateEventScreen(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<BottomNavController>(
      builder: (context, controller, child) {
        return Scaffold(
          extendBody: true,
          body: _pages[controller.selectedIndex],
          bottomNavigationBar: Container(
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              child: Container(
                height: 72.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final bool isSelected = controller.selectedIndex == index;

                    final List<String> icons = [
                      'assets/images/home.png',
                      'assets/images/location.png',
                      '', // Placeholder for icon since we will use IconData or a custom widget for "Create"
                      'assets/images/chat.png',
                      'assets/images/profile_icon.png',
                    ];

                    final List<String> labels = [
                      'Home',
                      'Map',
                      'Create',
                      'Chat',
                      'Profile',
                    ];

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.onItemTapped(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                index == 2
                                    ? Icon(
                                        Icons.add_box_outlined,
                                        size: 24.sp.clamp(24, 26),
                                        color: isSelected
                                            ? (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                            : (isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade600),
                                      )
                                    : Image.asset(
                                        icons[index],
                                        width: 24.w.clamp(24, 26),
                                        height: 24.h.clamp(24, 26),
                                        color: isSelected
                                            ? (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                            : (isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade600),
                                      ),
                                if (index == 3 &&
                                    !isSelected) // Chat Icon and NOT selected
                                  Consumer<ChatController>(
                                    builder: (context, chatController, _) {
                                      debugPrint(
                                        "🎨 BottomNavBar - Chat Badge Build: unreadCount=${chatController.unreadCount}",
                                      );
                                      if (chatController.unreadCount > 0) {
                                        return Positioned(
                                          right: -6.w,
                                          top: -4.h,
                                          child: Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 16.w,
                                              minHeight: 16.h,
                                            ),
                                            child: Text(
                                              chatController.unreadCount
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 10.sp.clamp(10, 11),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,

                                // ⭐ Text Color Logic
                                color: isSelected
                                    ? (isDark
                                          ? Colors.white
                                          : Colors.black) // Selected
                                    : (isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade600),
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
      },
    );
  }
}
