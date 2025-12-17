import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ReivewController extends ChangeNotifier {
  final bool _inProgress = false;
  String? _errorMessage;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> submitReview(
    String eventId,
    String reviewText,
    int rating,
  ) async {
    bool _inProgress = false;
    bool isSuccess = false;
    notifyListeners();
    final Map<String, dynamic> requestBody = {
      "eventId": eventId,
      "reviewText": reviewText,
      "rating": rating,
    };

    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.reviewUrl,
        body: requestBody as Map<String, String>?,
      );

      if (response.isSuccess) {
        isSuccess = true;
        _inProgress = false;
        notifyListeners();
      } else {
        isSuccess = false;
        _inProgress = false;
        notifyListeners();
        throw Exception('Failed to submit review: ${response.errorMessage}');
      }
    } catch (e) {
      _errorMessage = "Something went wrong! Please try again.";
    } finally {
      _inProgress = false;
      notifyListeners();
    }

    return isSuccess;
  }
}
