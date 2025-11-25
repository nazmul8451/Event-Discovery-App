import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart' show BottomNavBarScreen;
import 'package:gathering_app/View/Screen/BottomNavBarScreen/home_page.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  static const String name = '/booking-confirm-screen';

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
                surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Back Button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
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
                  'Sunset Rooftop Party',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
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
                          Text('Order ID',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Text('ORD-7J68GPVDV',style: Theme.of(context).textTheme.titleSmall,),
                        ],
                      ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Event',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text('Sunset Rooftop Party',style: Theme.of(context).textTheme.titleSmall,),
                          ],
                        ),

                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Event',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text('Sunset Rooftop Party',style: Theme.of(context).textTheme.titleSmall,),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text('Nov 8 at 6:00 PM',style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ticket Type',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text('General Admission',style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                            Text('1',style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),

                        SizedBox(height: 10.h,),
                        Divider(color: Color(0xFFCC18CA).withOpacity(0.15)),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Paid',style: Theme.of(context).textTheme.titleSmall),
                            Text('\$49.50',style: Theme.of(context).textTheme.titleSmall?.copyWith(color:Color(0xFFCC18CA) )),
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
                      
                      Text('1 ticket has been sent to example@gmail.com',style:Theme.of(context).textTheme.bodySmall)
            
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h,),

            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBarScreen())),
              child: CustomButton(buttonName: 'Back To Events')),
              
              //close this body
            ],
          ),
        ),
      ),
    );
  }
}
