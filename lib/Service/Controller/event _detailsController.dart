import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_single_event_model.dart';
import 'package:gathering_app/Service/urls.dart';
import '../Api service/network_caller.dart';

class EventDetailsController extends ChangeNotifier {
  bool inProgress = false;
  String? errorMessage;
  SingleEventDataModel? singleEvent;

  Future<void> getSingleEvent(String eventId) async {
    inProgress = true;
    errorMessage = null;
    singleEvent = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getSingleEvent(eventId),
      );

      print("=====================Raw Response========================");
      print(response.body);

      if (response.isSuccess) {
        final Map<String, dynamic> responseBody = response.body is String
            ? jsonDecode(response.body as String)
            : response.body;
        if (responseBody['success'] == true && responseBody['data'] != null) {
          singleEvent = SingleEventDataModel.fromJson(responseBody);
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
}
