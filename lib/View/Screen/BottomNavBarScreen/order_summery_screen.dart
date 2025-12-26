
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/event _detailsController.dart';
import 'package:provider/provider.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/Service/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/booking_confirmed.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({super.key});

  static const String name = "/order-summery";

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  Future<void> _handlePayment(
    BuildContext context,
    int totalPrice,
    String title, {
    String? ticketId,
    required String date,
    required String time,
    required String location,
    required int quantity,
    required int price,
    required String eventId,
    String imageUrl = '',
  }) async {
    try {
      final int amount = totalPrice * 100;

      // Call backend to create a checkout session or payment intent (pass ticketId)
      final String session = await StripeService.createPayment(
        amount: amount.toString(),
        currency: 'usd',
        ticketId: ticketId,
      );

      // If backend returned a URL, open it in external browser.
      if (session.startsWith('http')) {
        final launched = await launchUrlString(session, mode: LaunchMode.externalApplication);
        if (!launched) throw Exception('Could not open checkout URL');
        // After redirecting to hosted checkout, refresh ticket status and navigate to confirmation.
        try {
          if (eventId.isNotEmpty) await context.read<EventDetailsController>().checkIfUserHasTicket(eventId);
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment started in browser')));
        Navigator.pushReplacementNamed(
          context,
          BookingConfirmedScreen.name,
          arguments: {
            'eventTitle': title,
            'eventDate': date,
            'eventTime': time,
            'eventLocation': location,
            'quantity': quantity,
            'price': price,
            'totalPaid': totalPrice,
            'ticketId': ticketId,
            'imageUrl': imageUrl,
            'eventId': eventId,
          },
        );
        return;
      }

      if (session.contains('secret_') || (session.startsWith('pi_') && session.contains('secret'))) {
        // Looks like a PaymentIntent client secret — try PaymentSheet.
        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: session,
              merchantDisplayName: 'Gathering App',
            ),
          );

          await Stripe.instance.presentPaymentSheet();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment successful')));
          // refresh ticket status on details controller so UI updates
          try {
            if (eventId.isNotEmpty) await context.read<EventDetailsController>().checkIfUserHasTicket(eventId);
          } catch (_) {}

          // Navigate to booking confirmed and pass event details
          Navigator.pushReplacementNamed(
            context,
            BookingConfirmedScreen.name,
            arguments: {
              'eventTitle': title,
              'eventDate': date,
              'eventTime': time,
              'eventLocation': location,
              'quantity': quantity,
              'price': price,
              'totalPaid': totalPrice,
              'ticketId': ticketId,
              'imageUrl': imageUrl,
              'eventId': eventId,
            },
          );
          return;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('PaymentSheet failed: $e — ensure flutter_stripe is configured and Stripe.publishableKey set'),
            duration: const Duration(seconds: 6),
          ));
          return;
        }
      }

      // fallback: assume session id for checkout
      final url = 'https://checkout.stripe.com/pay/$session';
      await launchUrlString(url, mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment started in browser')));
      try {
        if (eventId.isNotEmpty) await context.read<EventDetailsController>().checkIfUserHasTicket(eventId);
      } catch (_) {}
      Navigator.pushReplacementNamed(
        context,
        BookingConfirmedScreen.name,
        arguments: {
          'eventTitle': title,
          'eventDate': date,
          'eventTime': time,
          'eventLocation': location,
          'quantity': quantity,
          'price': price,
          'totalPaid': totalPrice,
          'ticketId': ticketId,
          'imageUrl': imageUrl,
          'eventId': eventId,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};

    final String title = (args['eventTitle'] ?? args['title'] ?? '')?.toString() ?? '';
    final String date = (args['eventDate'] ?? args['date'] ?? '')?.toString() ?? '';
    final String time = (args['eventTime'] ?? args['time'] ?? '')?.toString() ?? '';
    final String location = (args['eventLocation'] ?? args['location'] ?? '')?.toString() ?? '';

    int quantity() {
      final v = args['quantity'];
      if (v == null) return 1;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 1;
    }

    int asInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? fallback;
    }

    final int qty = quantity();
    final int price = asInt(args['price'], 0);
    final int totalPrice = asInt(args['totalPaid'] ?? args['totalPrice'], price * qty);
    final String imageUrl = (args['imageUrl'] ?? '')?.toString() ?? '';
    final String? ticketId = (args['ticketId'] ?? args['ticket_id'] ?? args['id'])?.toString();
    final String eventId = (args['eventId'] ?? args['event_id'] ?? '')?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Order summary')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFCC18CA).withOpacity(0.15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.withOpacity(0.15),
                        ),
                        child: Center(
                          child: (imageUrl.isNotEmpty)
                              ? Image.network(
                                  '${Urls.baseUrl}$imageUrl',
                                  height: 100.h,
                                  width: 100.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 40,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                        ),
                      ),

                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/calender_icon.png',
                                  height: 16.h,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon.png',
                                  height: 16.h,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFCC18CA).withOpacity(0.15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("${title}",softWrap: true,maxLines: 1,overflow: TextOverflow.ellipsis,)),
                          Expanded(
                            flex: 1,
                            child: Text('Event price: \\${price}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Divider(color: const Color(0xFFCC18CA).withOpacity(0.15)),
                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                           ' \$$totalPrice',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonName: 'Proceed to payment',
                        onPressed: () async {
                          await _handlePayment(
                            context,
                            totalPrice,
                            title,
                            ticketId: ticketId,
                            date: date,
                            time: time,
                            location: location,
                            quantity: qty,
                            price: price,
                            eventId: eventId,
                            imageUrl: imageUrl,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}