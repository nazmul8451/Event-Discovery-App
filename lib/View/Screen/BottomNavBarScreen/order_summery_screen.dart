import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/Service/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({super.key});

  static const String name = "/order-summery";

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  Future<void> _handlePayment(BuildContext context, int totalPrice, String title, {String? ticketId}) async {
    try {
      if (ticketId == null || ticketId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket ID missing')));
        return;
      }

      final int amount = totalPrice * 100;
      // Call backend to create a checkout session or payment intent (pass ticketId)
      final String session = await StripeService.createPayment(amount: amount.toString(), currency: 'usd', ticketId: ticketId);

      // If backend returned a URL, open it in external browser.
      if (session.startsWith('http')) {
        final launched = await launchUrlString(session, mode: LaunchMode.externalApplication);
        if (!launched) throw Exception('Could not open checkout URL');
      } else if (session.contains('secret_') || (session.startsWith('pi_') && session.contains('secret'))) {
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
          Navigator.pushNamed(context, '/booking-confirmed');
        } catch (e) {
          // Provide actionable error message — common cause: flutter_stripe not configured/initialized on native side.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('PaymentSheet failed: $e — ensure flutter_stripe is configured and Stripe.publishableKey set in main.dart'),
            duration: const Duration(seconds: 6),
          ));
        }
      } else {
        // fallback: assume session id for checkout
        final url = 'https://checkout.stripe.com/pay/$session';
        final launched = await launchUrlString(url, mode: LaunchMode.externalApplication);
        if (!launched) throw Exception('Could not open checkout URL');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String title = args["eventTitle"];
    final String date = args["eventDate"];
    final String time = args["eventTime"];
    final String location = args["eventLocation"];
    final int quantity = args["quantity"];
    final int price = args["price"];
    final int totalPrice = args["totalPrice"];
    final String imageUrl = args["imageUrl"] ?? '';
    final String? ticketId = (args["ticketId"] ?? args["ticket_id"] ?? args["eventId"] ?? args["event_id"] ?? args["id"])?.toString();

    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('Order summery')),
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
                            height: 100.h,
                            width: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.15),
                            ),
                            child: Center(
                              child: (imageUrl != null && imageUrl.isNotEmpty)
                                  ? Image.network(
                                      '${Urls.baseUrl}$imageUrl',
                                      height: 100.h,
                                      width: 100.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                              size: 40,
                                            );
                                          },
                                    )
                                  : Icon(
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
                                  '${title}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 16.sp.clamp(16, 17)),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/calender_icon.png',
                                      height: 16.h,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        '${time}',
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
                                        '${location}',
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
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: SizedBox(
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
                              Text('$title'),
                              Text('Event price: ${price}'),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          Divider(color: Color(0xFFCC18CA).withOpacity(0.15)),
                          SizedBox(height: 10.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '\$${totalPrice}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            buttonName: 'Proceed to payment',
                            onPressed: () async {
                              await _handlePayment(context, totalPrice, title, ticketId: ticketId);
                            },
                          ),
                        ],
                      ),
                    ),
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
