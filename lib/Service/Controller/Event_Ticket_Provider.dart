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

  Future<bool> checkIn(String ticketId) async {
    print("🎟️ Attempting check-in for ticketId: $ticketId");
    _setStatus(TicketStatus.loading);
    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.checkInUrl,
        body: {"_id": ticketId},
        requireAuth: true,
      );

      print("🎟️ Check-in Response Status: ${response.statusCode}");
      print("🎟️ Check-in Response Body: ${response.body}");

      if (response.isSuccess) {
        print("✅ Check-in successful!");
        _setStatus(TicketStatus.checkedIn);
        return true;
      } else {
        print("❌ Check-in failed: ${response.errorMessage}");
        _setStatus(TicketStatus.purchased);
        return false;
      }
    } catch (e) {
      print("⚠️ Check-in Exception: $e");
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

  void _setStatus(TicketStatus status) {
    _status = status;
    notifyListeners();
  }
}
