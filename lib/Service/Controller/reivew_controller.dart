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
    required double rating,
  }) async {
    if (reviewText.trim().isEmpty) {
      _errorMessage = "Please write a review";
      notifyListeners();
      return false;
    }

    if (rating < 1 || rating > 5) {
      _errorMessage = "Rating must be between 1 and 5";
      notifyListeners();
      return false;
    }

    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "eventId": eventId.trim(),
      "reviewText": reviewText.trim(),
      "rating": rating,
    };

    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.reviewUrl,
        body: requestBody,
        requireAuth: true, 
      );

      if (response.isSuccess) {
        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        String msg = "Failed to submit review";
        if (response.body is Map) {
          final map = response.body as Map;
          if (map['errorMessages'] is List && (map['errorMessages'] as List).isNotEmpty) {
            msg = map['errorMessages'][0]['message'];
          } else if (map['message'] is String) {
            msg = map['message'];
          }
        }
        _errorMessage = msg;
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "No internet connection or server error";
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}