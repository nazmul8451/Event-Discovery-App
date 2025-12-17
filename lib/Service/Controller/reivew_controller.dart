import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ReivewController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> submitReview({
    required String eventId,
    required String reviewText,
    required double rating,  // int এর পরিবর্তে double রাখো, কারণ half rating আসতে পারে
  }) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "eventId": eventId,
      "reviewText": reviewText.trim(),
      "rating": rating,
    };

    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.reviewUrl,
        body: requestBody,
      );

      if (response.isSuccess) {
        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to submit review";
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong! Please try again.";
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }
}