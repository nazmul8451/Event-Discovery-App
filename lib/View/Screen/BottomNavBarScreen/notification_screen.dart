import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String name = 'notification-screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20.sp.clamp(20, 22),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 Text(
                  'Stay updated with your events',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
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
                  child: Image.asset('assets/images/cross_icon.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Consumer<ThemeProvider>(
                    builder: (context, controller, child) => SizedBox(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Color(0xFFB026FF)),
                        ),
                        child: ListTile(
                          leading: Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink,
                            ),
                          ),
                          title: Text(
                            'New event near you: Midnight Groove',
                            style: TextStyle(
                              color: controller.isDarkMode
                                  ? Color(0xFFF0F0F5)
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '2 hours ago',
                            style: TextStyle(
                              color: controller.isDarkMode
                                  ? Color(0xFFF0F0F5)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(buttonName: 'Mark all as read'),
            ),
          ],
        ),
      ),
    );
  }
}
