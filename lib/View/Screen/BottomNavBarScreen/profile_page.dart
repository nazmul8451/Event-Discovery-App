import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
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
  bool notificationSwitch = false;

  final List<Map<String, dynamic>> categories = [
    {"label": "All", "icon": Icons.auto_awesome},
    {"label": "Nightlife", "icon": Icons.nights_stay_outlined},
    {"label": "Music", "icon": Icons.music_note_outlined},
    {"label": "Concerts", "icon": Icons.mic_none_outlined},
    {"label": "Food & Drinks", "icon": Icons.local_drink_outlined},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().initialize();
      context.read<ProfileController>().fetchProfile();
    });
  }
  @override
void dispose() {
  nameController.dispose();
  emialController.dispose();
  phoneController.dispose();
  locationController.dispose();
  bioController.dispose();
  super.dispose();
}

  TextEditingController nameController = TextEditingController();
  TextEditingController emialController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bioController = TextEditingController();

void _showEditProfileDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;



  // ProfileController থেকে current user নিয়ে controllers-এ value সেট করা
  final profileController = context.read<ProfileController>();
  final currentUser = profileController.currentUser;

  if (currentUser != null) {
    nameController.text = currentUser.name ?? '';
    emialController.text = currentUser.email ?? '';
    // phoneController.text = currentUser. ?? ''; // model-এ phone থাকলে
    locationController.text = currentUser.location?.type ?? '';
    bioController.text = currentUser.description ?? ''; 
  }

  bool isLoading = false; // Save button-এ loading দেখানোর জন্য

  showDialog(
    context: context,
    barrierDismissible: !isLoading, // loading থাকলে dialog বন্ধ করা যাবে না
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Update your personal information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: isLoading ? null : () => Navigator.pop(context),
                        child: Container(
                          height: 40.r,
                          width: 40.r,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3E043F)
                                : const Color(0xFF686868),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset('assets/images/cross_icon.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Form Fields
                  Column(
                    children: [
                      AuthTextField(
                        hintText: 'user name',
                        labelText: 'Name',
                        controller: nameController,
                      ),
                      SizedBox(height: 16.h),
                      AuthTextField(
                        hintText: 'your email',
                        labelText: 'Email',
                        controller: emialController,
                      ),
                      SizedBox(height: 16.h),
                      AuthTextField(
                        hintText: '+43 04324',
                        labelText: 'Phone',
                        controller: phoneController,
                      ),
                      SizedBox(height: 16.h),
                      AuthTextField(
                        hintText: 'Change Location',
                        labelText: 'Location',
                        controller: locationController,
                      ),
                      SizedBox(height: 16.h),
                      AuthTextField(
                        hintText: 'Tell about yourself',
                        labelText: 'Your bio',
                        controller: bioController,
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: isDark ? Colors.white70 : Colors.black54,
                            elevation: 0,
                            side: BorderSide(color: isDark ? Colors.white38 : Colors.black38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  bool success = await profileController.updateProfile(
                                     nameController.text.trim().isEmpty
                                        ? null
                                        : nameController.text.trim(),
                                     emialController.text.trim().isEmpty
                                        ? null
                                        : emialController.text.trim(),
                                     bioController.text.trim().isEmpty
                                        ? null
                                        : bioController.text.trim(),
                                     phoneController.text.trim().isEmpty
                                        ? null
                                        : phoneController.text.trim()
                                  );

                                  if (success) {
                                    if (mounted) {
                                      Navigator.pop(context); // dialog close
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Profile updated successfully! 🎉"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            profileController.errorMessage ??
                                                "Failed to update profile",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save Change',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
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
        );
      },
    ),
  );


}
  Future<void> _saveProfileChanges() async {
    final controller = context.read<ProfileController>();
    bool isSuccess = await controller.updateProfile(
      nameController.text.trim(),
      emialController.text.trim(),
      bioController.text.trim(),
      locationController.text.trim(),
    );
    if(isSuccess){
      showCustomSnackBar(context: context, message:"Profile updated successfully! 🎉" );
      Navigator.pop(context);
    }else{
      showCustomSnackBar(context: context, message: controller.errorMessage ?? "Failed to update profile", isError: true);
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(image: AssetImage('assets/images/instagram.png')),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<ThemeProvider>(
        builder: (context, controller, child) {
          return Consumer<ProfileController>(
            builder: (context, profileController, child) {
              final user = profileController.currentUser;
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100.h,
                              width: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Provider.of<ThemeProvider>(
                                      context,
                                    ).isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.grey[200],
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
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
                                  '${user?.name}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.copyWith(),
                                ),
                                Text(
                                  '${user?.email}',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(color: Colors.grey),
                                ),
                                Text(
                                  'HTX | DTX | ∮ Good vibes only',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color:
                                            Provider.of<ThemeProvider>(
                                              context,
                                            ).isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color:
                                            Provider.of<ThemeProvider>(
                                              context,
                                            ).isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color:
                                            Provider.of<ThemeProvider>(
                                              context,
                                            ).isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),

                        // SizedBox(height: 55.h,child: ElevatedButton(onPressed: (){}, child: Text('Edit Profile')),),
                        Row(
                          children: [
                            // Expanded(child: GestureDetector(
                            //   onTap: ()=>_showEditProfileDialog(context),
                            //   child: CustomButton(buttonName: 'Edit Profile'))),
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _showEditProfileDialog(context),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        ///favorite spots
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'FAVORITE SPOTS',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),

                        SizedBox(height: 15.h),
                        //favorite spots list
                        SizedBox(
                          height: 230.h,
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
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
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
                                        // color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              // Filter Chips
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: categories.asMap().entries.map((
                                    entry,
                                  ) {
                                    int index = entry.key;
                                    var category = entry.value;
                                    bool isSelected =
                                        selectedCategoryIndex == index;

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
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60.h,
                                          width: 60.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(
                                              0xFFCC18CA,
                                            ).withOpacity(0.15),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
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
                                              .titleSmall!
                                              .copyWith(
                                                fontSize: 12.sp.clamp(12, 12),
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
                                            color: Color(
                                              0xFFCC18CA,
                                            ).withOpacity(0.15),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
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
                                              .titleSmall!
                                              .copyWith(
                                                fontSize: 12.sp.clamp(12, 12),
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
                                            color: Color(
                                              0xFFCC18CA,
                                            ).withOpacity(0.15),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
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
                                              .titleSmall!
                                              .copyWith(
                                                fontSize: 12.sp.clamp(12, 12),
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
                            Padding(
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
                                                        fontSize: 10.sp.clamp(
                                                          10,
                                                          13,
                                                        ),
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
                                                        fontSize: 10.sp.clamp(
                                                          10,
                                                          13,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.78,
                                              child: Switch(
                                                value: notificationSwitch,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    notificationSwitch =
                                                        newValue;
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
                                                  'Location Services',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  'Find events near you',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontSize: 10.sp.clamp(
                                                          10,
                                                          13,
                                                        ),
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
                                                  'Profile Status',
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
                                                        fontSize: 10.sp.clamp(
                                                          10,
                                                          13,
                                                        ),
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
                                                SizedBox(height: 4.h),
                                                Text(
                                                  Provider.of<ThemeProvider>(
                                                        context,
                                                      ).isDarkMode
                                                      ? 'Currently Dark'
                                                      : 'Currently Light',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 10.sp.clamp(
                                                          10,
                                                          13,
                                                        ),
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Transform.scale(
                                              scale: 0.85,
                                              child: Switch(
                                                value:
                                                    Provider.of<ThemeProvider>(
                                                      context,
                                                    ).isDarkMode,
                                                onChanged: (value) {
                                                  Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false,
                                                  ).toggleTheme();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20.h),
                                        Divider(
                                          color: Color(
                                            0xFFCC18CA,
                                          ).withOpacity(0.15),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),
                            Padding(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
