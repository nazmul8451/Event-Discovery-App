import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart' show BottomNavBarScreen;
import 'package:gathering_app/View/Screen/BottomNavBarScreen/details_screen.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:get_storage/get_storage.dart';

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  static const String name = '/booking-confirm-screen';

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String eventTitle = args?['eventTitle'] ?? 'Event';
    final String eventDate = args?['eventDate'] ?? '';
    final String eventTime = args?['eventTime'] ?? '';
    final String eventLocation = args?['eventLocation'] ?? '';
    final int quantity = args?['quantity'] ?? 1;
    final dynamic totalPaid = args?['totalPaid'] ?? '';
    final String orderId = args?['orderId'] ?? args?['ticketId'] ?? 'ORD-UNKNOWN';
    final String? eventId = args?['eventId'];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
                surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, controller, child) => GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 36.r,
                  width: 36.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: controller.isDarkMode
                        ? const Color(0xFF3E043F)
                        : const Color(0xFF686868),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Confirmed',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  eventTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        //start this body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: Image.asset(
                      'assets/images/booking_confirm_Icon.png',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                textAlign: TextAlign.center,
                'Your payment was successful. Check your email for tickets.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 20.h),

              SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFCC18CA).withOpacity(0.15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Order Details',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            SizedBox(
                              child: Container(
                              
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00C950).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF00C950),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Confirmed'),
                                ),
                              ),
                            ),
                          ],
                        ),
                                                SizedBox(height: 20.h),

                                                Divider(color: Color(0xFFCC18CA).withOpacity(0.15)),

                        SizedBox(height: 20.h),

                                            Column(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order ID', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Text(orderId, style: Theme.of(context).textTheme.titleSmall,),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Event', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Text(eventTitle, style: Theme.of(context).textTheme.titleSmall,),
                        ],
                      ),

                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Expanded(
                            child: Text(eventLocation, textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleSmall,),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Text('$eventDate ${eventTime.isNotEmpty ? 'at $eventTime' : ''}', style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ticket Type', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text((ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>?)?['ticketType'] ?? 'General Admission', style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),

                        SizedBox(height: 10.h,),
                        Divider(color: Color(0xFFCC18CA).withOpacity(0.15)),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Paid', style: Theme.of(context).textTheme.titleSmall),
                            Text('${totalPaid is num ? '\$${totalPaid}' : totalPaid.toString()}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Color(0xFFCC18CA) )),
                          ],
                        ),
                    ],
                    ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h,),
                            SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFCC18CA).withOpacity(0.15),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                      Color(0xFFCC18CA).withOpacity(0.10),
                       Color(0xFFFF006E).withOpacity(0.10),
                    ],
                
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),


                        Row(
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: Image.asset('assets/images/ticket_icon_mini.png'),
                            ),
                            SizedBox(width: 10.w,),
                            Text('Your Ticket',style:Theme.of(context).textTheme.bodyMedium),                          ],
                        ),
                        SizedBox(height:30.h,),
                      
                      Builder(builder: (context) {
                        final argsMap = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                        final profile = Provider.of<ProfileController>(context, listen: false);
                        String? email = argsMap?['email'] ?? profile.currentUser?.email;

                        // Fallback: try GetStorage cached profile
                        if ((email == null || email.isEmpty)) {
                          try {
                            final storage = GetStorage();
                            final cached = storage.read('cached_user_profile');
                            if (cached is Map && cached['email'] != null) {
                              email = cached['email'].toString();
                            }
                          } catch (_) {
                            // ignore
                          }
                        }

                        final String displayEmail = (email == null || email.isEmpty) ? 'example@gmail.com' : email;
                        final int qty = argsMap?['quantity'] ?? quantity;
                        final String plural = qty > 1 ? 'tickets' : 'ticket';
                        return Text('$qty $plural have been sent to $displayEmail', style: Theme.of(context).textTheme.bodySmall);
                      })
            
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h,),

            GestureDetector(
              onTap: () {
                if (eventId != null && eventId.isNotEmpty) {
                  Navigator.pushReplacementNamed(
                    context,
                    DetailsScreen.name,
                    arguments: eventId,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavBarScreen()),
                  );
                }
              },
              child: const CustomButton(buttonName: 'Back To Events')),
              
              //close this body
            ],
          ),
        ),
      ),
    );
  }
}
