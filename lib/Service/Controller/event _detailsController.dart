import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_single_event_model.dart';
import 'package:gathering_app/Service/urls.dart';
import '../Api service/network_caller.dart';

class EventDetailsController extends ChangeNotifier {
  bool inProgress = false;
  String? errorMessage;
  SingleEventDataModel? singleEvent;
  // whether current user has a ticket for this event
  bool hasTicket = false;
  // optional ticket id for the user
  String? userTicketId;

  Future<void> getSingleEvent(String eventId) async {
    inProgress = true;
    errorMessage = null;
    singleEvent = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getSingleEvent(eventId),
        token: "",
      );

      print("=====================Response========================");
      print(response.body);

      if (response.isSuccess) {
        final Map<String, dynamic> responseBody = response.body is String
            ? jsonDecode(response.body as String)
            : response.body;
        if (responseBody['success'] == true && responseBody['data'] != null) {
          singleEvent = SingleEventDataModel.fromJson(responseBody);
          // after loading event details, check if user has ticket
          checkIfUserHasTicket(eventId);
        } else {
          errorMessage = responseBody['message'] ?? "No data found";
        }
      } else {
        errorMessage = response.errorMessage ?? "Request failed";
      }
    } catch (e) {
      errorMessage = "Exception: $e";
      print("Error in getSingleEvent: $e");
    } finally {
      inProgress = false;
      notifyListeners();
    }
  }

  /// Check whether current user already has a ticket for [eventId]
  Future<void> checkIfUserHasTicket(String eventId) async {
    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getHasTicket(eventId),
        requireAuth: true,
      );

      if (response.isSuccess && response.body != null) {
        final Map<String, dynamic> body = response.body!;
        // expected response: { hasTicket: bool, ticketId?: string }
        final bool found = (body['hasTicket'] == true) || (body['data']?['hasTicket'] == true);
        hasTicket = found;
        // ticket id can be in several places depending on backend shape
        userTicketId = body['ticketId']?.toString() ?? body['data']?['ticketId']?.toString() ?? body['data']?['ticket']?['id']?.toString();
      } else {
        hasTicket = false;
        userTicketId = null;
      }
    } catch (e) {
      hasTicket = false;
      userTicketId = null;
    }

    notifyListeners();
  }
}
