import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/widget_controller/interestScreenController.dart';
import 'package:provider/provider.dart';

class InterestScreen extends StatelessWidget {
  InterestScreen({super.key});

  static const String name = 'interest-screen';

  final List<Map<String, dynamic>> interestItems = [
    {'icon': "assets/images/music_icon.png", 'name': 'Live Music'},
    {'icon': "assets/images/nightlife_icon.png", 'name': 'Nightlife'},
    {'icon': "assets/images/concerts_icon.png", 'name': 'Concerts'},
    {'icon': "assets/images/foodandDrinks_icon.png", 'name': 'Food & Drinks'},
    {'icon': "assets/images/comedy_icon.png", 'name': 'Comedy'},
    {'icon': "assets/images/art_culture_icon.png", 'name': 'Art & Culture'},
    {'icon': "assets/images/wellness_icon.png", 'name': 'Wellness'},
    {'icon': "assets/images/networking_icon.png", 'name': 'Networking'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'What interests you?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'Select your favorite event types to personalize\nyour feed',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<InterestScreenController>(
                  builder: (context, controller, child) {
                    return GridView.builder(
                      itemCount: interestItems.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = controller.selectedItems.contains(
                          index,
                        );
                        var item = interestItems[index];
                        return GestureDetector(
                          onTap: () {
                            controller.toggleSelection(index);
                          },
                          child: Container(
                            // height: 187.h,width: 150.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: Color(0xFFE2E8F0),
                                      width: 1,
                                    ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60.h,
                                        width: 60.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFF1F3F5),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            item['icon'],
                                            height: 31.h,
                                            width: 31.h,
                                            color: isSelected
                                                ? Colors.black
                                                : Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: isSelected
                                              ? Colors.black
                                              : Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xFFB026FF),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Consumer<InterestScreenController>(
                builder: (context, controller, child) {
                  if (controller.selectedItemCount == 0) {
                    return Text(
                      'Please select at least one item',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return GestureDetector(
                      onTap: (){
                        //TODO: NAVIGATE LOG IN SCREEN
                        Navigator.pushNamed(context, LogInScreen.name);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomButton(
                          buttonName: 'Continue (${controller.selectedItemCount} selected)',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
