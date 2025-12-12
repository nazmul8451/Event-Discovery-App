import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Api service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class GetAllEventController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  List<EventData> _allEvents = [];
  List<EventData> _filteredEvents = [];

  List<String> _categories = ["All"];
  String _selectedCategory = "All";

  // Getters
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  List<EventData> get events => _filteredEvents;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  /// =========================
  /// 🔥 Fetch All Events + Categories
  /// =========================
  Future<bool> getAllEvents() async {
    _inProgress = true;
    notifyListeners();

    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OTNiM2VlMjAxNDcwOTJlZWUyMTY5OWUiLCJyb2xlIjoidXNlciIsIm5hbWUiOiJraGFsdCIsImVtYWlsIjoib2p6N3pia3dpNEBtcm90emlzLmNvbSIsImlhdCI6MTc2NTU2NjE3MSwiZXhwIjoxNzY2NDMwMTcxfQ.QEJQZfSlcgKLcQT_BZ46pBmRqwz0mHTceV7bDCCXHko';

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getAllEvent,
        token: token,
      );

      print('Token: $token');
      print('STATUS CODE: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Handle response body type safely
        Map<String, dynamic> body;
        if (response.body is String) {
          body = jsonDecode(response.body as String);
        } else if (response.body is Map<String, dynamic>) {
          body = response.body!;
        } else {
          throw Exception("Invalid response body type");
        }

        List rawEvents = body["data"]["data"];

        // All events
        _allEvents = rawEvents.map((e) => EventData.fromJson(e)).toList();

        // Debugging print for readable output
        for (var e in _allEvents) {
          print('Event Description: ${e.description}, Category: ${e.category}');
        }

        // Extract categories
        _categories = ["All"];
        for (var e in _allEvents) {
          if (e.category != null && e.category!.trim().isNotEmpty) {
            _categories.add(e.category!.trim().capitalize());
          }
        }

        // Remove duplicates and sort
        _categories = _categories.toSet().toList();
        _categories.sort();

        // Apply default filter
        applyCategoryFilter("All");

        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        print('Failed API Call');
        _errorMessage = "Failed to fetch events";
      }
    } catch (e) {
      print('Error fetching events: $e');
      _errorMessage = e.toString();
    }

    _inProgress = false;
    notifyListeners();
    return false;
  }

  /// =========================
  /// 🔥 Apply Filter
  /// =========================
  void applyCategoryFilter(String category) {
    _selectedCategory = category;

    if (category == "All") {
      _filteredEvents = [..._allEvents];
    } else {
      _filteredEvents = _allEvents
          .where(
            (e) =>
                e.category?.toLowerCase().trim() ==
                category.toLowerCase().trim(),
          )
          .toList();
    }

    notifyListeners();
  }
}

/// Simple extension for capitalizing category name
extension StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
