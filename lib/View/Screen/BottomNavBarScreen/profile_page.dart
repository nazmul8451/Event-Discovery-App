import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedCategoryIndex = 0;
  bool showSettingsCard = false;
  bool switchON = false;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    void CustomAlertDialogue(BuildContext context) {
      // context নিবে
      showDialog(
        context: context, // এখন ঠিক আছে
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(color: isDark? Colors.white: Colors.black,fontSize: 25.sp,fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Update your personal information",
                            style:TextStyle(color: isDark? Colors.white: Colors.black,fontSize: 15.sp,fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Consumer<ThemeProvider>(
                        builder: (context, controller, child) => GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 40.w,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: controller.isDarkMode
                                  ? Color(0xFF3E043F)
                                  : Color(0xFF686868),
                              // image: DecorationImage(image: AssetImage('assets/images/cross_icon.png',))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/cross_icon.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // তোমার ফর্ম ফিল্ড
                  AuthTextField(hintText: 'user name', labelText: 'Name'),
                  AuthTextField(hintText: 'your email', labelText: 'Email'),
                  AuthTextField(hintText: '+43 04324', labelText: 'Phone'),
                  AuthTextField(
                    hintText: 'Change Location',
                    labelText: 'Location',
                  ),
                  AuthTextField(hintText: 'Bio', labelText: 'Your bio'),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 55.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark? Colors.black: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Save Change',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: isDark? Colors.white: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 55.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:isDark? Colors.black : Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                          ),
                          onPressed: (){

                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: isDark? Colors.white: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.grey[500] : Colors.grey[200],
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rimon Islam',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(),
                        ),
                        Text(
                          '@nicholasfrazier96',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                        ),
                        Text(
                          'HTX | DTX | ∮ Good vibes only',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '10',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Events',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: isDark ? Colors.grey : Colors.black,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '432',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: isDark ? Colors.grey : Colors.black,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '322',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Following',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: isDark ? Colors.grey : Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 55.h,
                      width: 180.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        onPressed: () => CustomAlertDialogue(context),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55.h,
                      width: 180.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        onPressed: () {
                          setState(() {
                            showSettingsCard = !showSettingsCard;
                          });
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                ///favorite spots
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'FAVORITE SPOTS',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),
                //favorite spots list
                SizedBox(
                  height: 230.h, // এই লাইনটা যোগ করো
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180.h,
                              width: 180.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/container_img.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Electric Feelgood',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Interests',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // Filter Chips
                      SingleChildScrollView(
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
                                    // পরে এখানে API filter call hobe
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 60.h,
                                  width: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFCC18CA).withOpacity(0.15),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        height: 20,
                                        width: 20,
                                        'assets/images/calender_icon.png',
                                        color: Color(0xFFB026FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '10',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 25.sp),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Events Attended',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: isDark
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 60.h,
                                  width: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFCC18CA).withOpacity(0.15),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        height: 20,
                                        width: 20,
                                        'assets/images/calender_icon.png',
                                        color: Color(0xFFB026FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '432',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 25.sp),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Reviews',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: isDark
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 60.h,
                                  width: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFCC18CA).withOpacity(0.15),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        height: 20,
                                        width: 20,
                                        'assets/images/calender_icon.png',
                                        color: Color(0xFFB026FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '322',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 25.sp),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Favorites',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: isDark
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: showSettingsCard
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(
                                        0xFFCC18CA,
                                      ).withOpacity(0.15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Settings',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                        SizedBox(height: 30.h),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Push Notification',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  'Get notified about events',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.78,
                                              child: Switch(
                                                value: switchON,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    switchON = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(
                                          color: Color(
                                            0xFFCC18CA,
                                          ).withOpacity(0.15),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email Notifications',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  'Receive event updates via email',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.78,
                                              child: Switch(
                                                value: switchON,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    switchON = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(
                                          color: Color(
                                            0xFFCC18CA,
                                          ).withOpacity(0.15),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Profile Status ',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  'Profile Public Or Private',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.78,
                                              child: Switch(
                                                value: switchON,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    switchON = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Dark Mode',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.78,
                                              child: Switch(
                                                value: switchON,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    switchON = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(
                                          color: Color(
                                            0xFFCC18CA,
                                          ).withOpacity(0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 20.h),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: showSettingsCard
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(
                                        0xFFCC18CA,
                                      ).withOpacity(0.15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Quick Actions',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                        Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(width: 5.w),
                                            Text(
                                              'Edit Profile',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            Icon(Icons.favorite_border),
                                            SizedBox(width: 5.w),

                                            Text(
                                              'Saved Events',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),

                                        Divider(
                                          color: Color(
                                            0xFFCC18CA,
                                          ).withOpacity(0.15),
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.logout_outlined,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              'Sign Out',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
