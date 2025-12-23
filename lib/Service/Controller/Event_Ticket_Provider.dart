import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

enum TicketStatus { loading, notPurchased, purchased, checkedIn, error }

class EventTicketProvider extends ChangeNotifier {
  TicketStatus _status = TicketStatus.loading;
  TicketStatus get status => _status;
  String? _eventId; // nullable রাখো
  String? get eventId => _eventId;

  Map<String, dynamic>?
  _ticketData; // backend থেকে পাওয়া ticket details (QR, etc.)
  Map<String, dynamic>? get ticketData => _ticketData;

  // final String eventId;
  // final BuildContext context; // API call-এর জন্য context লাগবে snackbar-এর জন্য

  // EventTicketProvider({required this.eventId, required this.context}) {
  //   checkTicketStatus();
  // }

  Future<bool> createTicket({
    required int quantity,
    required int price,
    required String eventId,
    String? promotionCode,
  }) async {
    _setStatus(TicketStatus.loading);
    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.CreateTicket,
        body: {
          "eventId": eventId,
          "price": price,
          "quantity": quantity,
          "promotionCode": promotionCode,
        },
        requireAuth: true,
      );

      if (response.isSuccess && response.body!['statusCode'] == 201) {
        _ticketData = response.body!['data'];
        _setStatus(TicketStatus.purchased);
        return true;
      } else {
        _setStatus(TicketStatus.notPurchased);
        return false;
      }
    } catch (e) {
      _setStatus(TicketStatus.error);
      return false;
    }
  }

  // নতুন: eventId set করার মেথড
  void setEventId(String newEventId) {
    if (_eventId != newEventId) {
      _eventId = newEventId;
      _status = TicketStatus.notPurchased; // reset
      _ticketData = null;
      notifyListeners();
    }
  }

  // Future<void> checkTicketStatus() async {
  //   _setStatus(TicketStatus.loading);
  //   try {
  //     // তোমার backend API call করো
  //     final response = await NetworkCaller.getRequest(
  //       Urls.checkTicketStatus(eventId), // তুমি URL বানিয়ে নাও
  //     );

  //     if (response.isSuccess) {
  //       final data = response.body['data'];
  //       if (data['has_ticket'] == true) {
  //         _ticketData = data['ticket'];
  //         if (data['checked_in'] == true) {
  //           _setStatus(TicketStatus.checkedIn);
  //         } else {
  //           _setStatus(TicketStatus.purchased);
  //         }
  //       } else {
  //         _setStatus(TicketStatus.notPurchased);
  //       }
  //     } else {
  //       _setStatus(TicketStatus.notPurchased);
  //     }
  //   } catch (e) {
  //     _setStatus(TicketStatus.error);
  //     showSnackBar("Failed to check ticket status");
  //   }
  // }

  // Future<void> startPurchaseFlow({
  //   required int quantity,
  //   required String email,
  //   required String phone,
  //   String? coupon,
  // }) async {
  //   _setStatus(TicketStatus.loading);
  //   try {
  //     // ১. Backend-এ PaymentIntent create করাও
  //     final response = await NetworkCaller.postRequest(
  //       Urls.createPaymentIntent(eventId),
  //       body: {
  //         "quantity": quantity,
  //         "email": email,
  //         "phone": phone,
  //         if (coupon != null && coupon.isNotEmpty) "coupon": coupon,
  //       },
  //     );

  //     if (!response.isSuccess) {
  //       throw "Payment intent failed";
  //     }

  //     final clientSecret = response.body['client_secret'];

  //     // ২. Stripe Payment Sheet ওপেন
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientSecret,
  //         merchantDisplayName: "Gathering App",
  //         style: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
  //       ),
  //     );

  //     await Stripe.instance.presentPaymentSheet();

  //     // ৩. Payment success → backend-এ confirm করো
  //     final confirmResponse = await NetworkCaller.postRequest(
  //       Urls.confirmTicketPurchase(eventId),
  //     );

  //     if (confirmResponse.isSuccess) {
  //       _ticketData = confirmResponse.body['ticket'];
  //       _setStatus(TicketStatus.purchased);
  //       showSnackBar("Ticket purchased successfully!", isError: false);
  //     }
  //   } on StripeException catch (e) {
  //     if (e.error.code == PaymentIntentsStatus.Canceled) {
  //       showSnackBar("Payment cancelled");
  //     } else {
  //       showSnackBar("Payment failed: ${e.error.message}");
  //     }
  //     _setStatus(TicketStatus.notPurchased);
  //   } catch (e) {
  //     showSnackBar("Error: $e");
  //     _setStatus(TicketStatus.notPurchased);
  //   }
  // }

  void _setStatus(TicketStatus status) {
    _status = status;
    notifyListeners();
  }
}
