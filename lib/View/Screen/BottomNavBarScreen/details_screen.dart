import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/get_single_event_model.dart';
import 'package:gathering_app/Service/Controller/event%20_detailsController.dart';
import 'package:gathering_app/Service/Controller/reivew_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/booking_confirmed.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/view_event_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:gathering_app/View/Widgets/details_event_highlightMessage.dart';
import 'package:gathering_app/View/Widgets/orgenizer_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../Widgets/auth_textFormField.dart';
import '../../Widgets/custom carosel_slider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  static const String name = '/details-screen';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late CarouselSliderController carouselController;
  SingleEventDataModel? singleEvent;
  double _currentRating = 5.0;
  final TextEditingController _reviewController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventId = ModalRoute.of(context)!.settings.arguments as String;
      context.read<EventDetailsController>().getSingleEvent(eventId);
      print("Event ID in Details Screen: $eventId");
    });

    carouselController = CarouselSliderController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventDetailsController>();
    final singleEvent = controller.singleEvent;

    if (controller.inProgress) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.errorMessage != null) {
      return Scaffold(body: Center(child: Text(controller.errorMessage!)));
    }

    if (singleEvent == null) {
      return const Scaffold(body: Center(child: Text('No event found')));
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    void WriteReviewAlertDialogue(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Consumer<ReivewController>(
          builder:(context,controller,child)=> AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.all(15.w),
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
                                  "Write a Review",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp.clamp(18, 20),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Share your experience at Electric Paradise Festival",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Consumer<ThemeProvider>(
                            builder: (context, controller, child) => GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 40,
                                width: 40,
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
                      SizedBox(height: 20.h),
                   // Rating Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rating', style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 35.h,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_border_outlined,
                              color: Colors.white,
                            ),
                            onRatingUpdate: (rating) {
                              _currentRating = rating;
                            },
                          ),
                          SizedBox(width: 10.w,),
                          Text('${_currentRating.toStringAsFixed(1)}')
                        ],
                      ),
                    ],
                  ),
                      SizedBox(height: 24.h),
                      AuthTextField(
                        controller: _reviewController,
                        hintText: 'Tell us about your experience...',
                        labelText: 'Your Review',
                      ),
                      SizedBox(height: 5.h),
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '0/500',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                children: [
                                  Text(
                                    'characters',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SizedBox(
                          width: double.infinity, // full width inside dialog
                          height: 55.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.black
                                  : Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.zero, // overflow রোধ
                            ),
                            onPressed: ()=>controller.inProgress? null: ()async{
                              if(_reviewController.text.trim().isEmpty){
                                showCustomSnackBar(context: context, message: "Please write a review");
                              }return ;
                            },
                            child: Text(
                              'Submit Review',
                              style: TextStyle(
                                fontSize: 15.sp.clamp(15, 15),
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    void GetTicketAlertDialogue(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: SizedBox(
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
                        // এই Column টাকে Expanded দিয়ে wrap করছি যাতে বাকি জায়গা নেয়
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Book Tickets',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                textAlign: TextAlign.center,
                                "Complete your booking for Live Jazz Night",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Consumer<ThemeProvider>(
                          builder: (context, controller, child) => GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 40,
                              width: 40,
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
                    AuthTextField(hintText: 'Summer 25', labelText: 'Coupon'),
                    AuthTextField(
                      hintText: '1',
                      labelText: 'Number of Tickets',
                    ),
                    AuthTextField(
                      hintText: 'Email',
                      labelText: 'your@email.com',
                    ),
                    AuthTextField(
                      hintText: 'Phone Number',
                      labelText: '+1 (555) 000-0000',
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: Color(0xFFCC18CA).withOpacity(0.15)),
                    SizedBox(height: 20.h),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Price per ticket',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              '\$30',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              '1',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '\$30',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: Color(0xFFCC18CA)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ), // দু’পাশে gap
                      child: SizedBox(
                        width: double.infinity, // full width inside dialog
                        height: 55.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.black
                                : Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.zero, // overflow রোধ
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmedScreen(),
                            ),
                          ),
                          child: Text(
                            'Confirm Booking',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, controller, child) => GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: controller.isDarkMode
                              ? Color(0xFF3E043F)
                              : Color(0xFF686868),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              size: 20.sp,
                              color: controller.isDarkMode
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, controller, child) => GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: controller.isDarkMode
                              ? Color(0xFF3E043F)
                              : Color(0xFF686868),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/cross_icon.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 50.w,
                    child: Image.asset('assets/images/fire_icon.png'),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${singleEvent?.data?.title}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 15.h,
                            width: 15.w,
                            child: Image.asset('assets/images/square.png'),
                          ),
                          SizedBox(width: 10.w),
                          Text('Official Gathering Location'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CircularPercentIndicator(
                radius: 80.r,
                lineWidth: 16,
                percent: 82 / 100,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "HOT",
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE77534),
                      ),
                    ),
                    Text(
                      "82",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 40.sp),
                    ),
                    Text(
                      "Steady crowd",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                linearGradient: LinearGradient(
                  colors: [
                    Color(0xFF201841),
                    Color(0xFF9E3C3C),
                    Color(0xFFE77534),
                  ],
                ),
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
                arcType: ArcType.HALF,
                // অর্ধবৃত্ত
                reverse: false,
                animation: true,
                animationDuration: 1000,
              ),

              SizedBox(height: 20.h),

              Consumer<ThemeProvider>(
                builder: (context, controller, child) => Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: Image.asset(
                              'assets/images/person.png',
                              color: controller.isDarkMode
                                  ? Color(0xFFFAFAFA)
                                  : Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text('Balanced Mix'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: Image.asset(
                              'assets/images/single_person.png',
                              color: controller.isDarkMode
                                  ? Color(0xFFFAFAFA)
                                  : Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text('25+ crowd'),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: Image.asset(
                              'assets/images/clock_icon.png',
                              color: controller.isDarkMode
                                  ? Color(0xFFFAFAFA)
                                  : Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text('10min entry'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              SizedBox(width: double.infinity, child: CustomCarousel()),

              SizedBox(height: 20.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20.h,
                        child: Image.asset('assets/images/person.png'),
                      ),
                      SizedBox(width: 10.w),
                      Text('678 attending'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              LinearPercentIndicator(
                width: 300.w,
                lineHeight: 10.0,
                percent: 0.80,
                // 0.0 to 1.0
                barRadius: const Radius.circular(20),
                backgroundColor: Colors.grey.shade300,
                progressColor: const Color(0xFFB620F8), // purple color
              ),

              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => GetTicketAlertDialogue(context),
                child: CustomButton(buttonName: 'Get Ticket'),
              ),
              SizedBox(height: 10.h),
              ContactOrgenizerButton(buttonName: "Contact Orgenizer"),

              // Align(
              //   alignment: Alignment.center,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         height: 20.h,
              //         child: Image.asset('assets/images/comment_icon.png'),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20.h),
              Container(
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
                      Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
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
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 16.sp.clamp(16, 17)),
                              ),
                              Text(
                                '${singleEvent?.data?.startDate}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 14.sp.clamp(14, 15)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
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
                      Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFCC18CA).withOpacity(0.15),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  height: 20,
                                  width: 20,
                                  'assets/images/clocksmall.png',
                                  color: Color(0xFFFF006E),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 16.sp.clamp(16, 17)),
                              ),
                              Text(
                                '${singleEvent?.data?.startTime}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 14.sp.clamp(14, 15)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Container(
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
                      Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFF00D9FF).withOpacity(0.15),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/colorful_location_icon.png',
                                  height: 20,
                                  width: 20,
                                  color: Color(0xFF00D9FF),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 16.sp.clamp(16, 17)),
                                ),
                                Text(
                                  singleEvent?.data?.address ??
                                      'No address available',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 14.sp.clamp(14, 15)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
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
                      Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFB026FF), Color(0xFFFF006E)],
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/B.png',
                                height: 15.h,
                                width: 15.w,
                                color: Colors.white, // সাদা করো
                                colorBlendMode:
                                    BlendMode.srcIn, // এই লাইনটা ম্যাজিক
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organized by',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 16.sp.clamp(16, 17)),
                              ),
                              Text(
                                'B${singleEvent?.data?.organizerId?.name ?? "Unknown"} ',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 16.sp.clamp(10, 13)),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 40.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFCC18CA).withOpacity(0.15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Follow',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About Event',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    singleEvent?.data?.description ??
                        'No description available',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Event Highlights',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              SizedBox(height: 10.h),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final List<String> highlights = [
                    'Live 5-piece band',
                    'Full cocktail bar',
                    'Intimate seating',
                    'Late night sessions',
                    'VIP balcony available',
                  ];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: DetailsHighlightMessage(message: highlights[index]),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 40.h,
                  width: 150.w,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFCC18CA).withOpacity(0.15),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border_outlined),
                          Text(
                            'Reviews (189)',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 40.h,
                    width: 150.w,
                    child: GestureDetector(
                      onTap: () => WriteReviewAlertDialogue(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFCC18CA).withOpacity(0.15),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star_border_outlined),
                              Text(
                                'Write Review',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Consumer<ThemeProvider>(
                builder: (context, controller, child) => SizedBox(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFB026FF).withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Alex K.',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Oct 2025',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w200,
                                            ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),
                                  Text(
                                    'Beautiful venue',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Spacer(),
                              RatingBarIndicator(
                                rating: 4.5,
                                itemBuilder: (context, index) =>
                                    const Icon(Icons.star, color: Colors.grey),
                                itemCount: 5,
                                itemSize: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Consumer<ThemeProvider>(
                builder: (context, controller, child) => SizedBox(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFB026FF).withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Jessica T.',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Oct 2025',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w200,
                                            ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),
                                  Text(
                                    'Beautiful venue',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Spacer(),
                              RatingBarIndicator(
                                rating: 4.5,
                                itemBuilder: (context, index) =>
                                    const Icon(Icons.star, color: Colors.grey),
                                itemCount: 5,
                                itemSize: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ViewEventScreen.name);
                },
                child: CustomButton(buttonName: 'View Event'),
              ),
              SizedBox(height: 20.h),
              //end
            ],
          ),
        ),
      ),
    );
  }
}
