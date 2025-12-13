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

  // =========================
  // ✅ Getters (UI safe)
  // =========================
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  /// Filtered events (based on category)
  List<EventData> get events => _filteredEvents;

  /// First 2 events → ListView
  
  List<EventData> get topTwoEvents {
    return _allEvents.take(2).toList(); // প্রথম ২টা
  }

  List<EventData> get remainingEvents {
    if (_allEvents.length <= 2) return [];
    return _allEvents.skip(2).toList(); // ২টার পরে বাকি
  }
// List<EventData> get remainingEvents {            
//   if (_filteredEvents.length <= 2) {
//     return [];
//   }
//   return _filteredEvents.take(_filteredEvents.length - 2).toList();
// }

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  // =========================
  // 🔥 Fetch All Events
  // =========================
  Future<bool> getAllEvents() async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoSWQiOiI2OTNiM2VlMjAxNDcwOTJlZWUyMTY5OWUiLCJyb2xlIjoidXNlciIsIm5hbWUiOiJraGFsdCIsImVtYWlsIjoib2p6N3pia3dpNEBtcm90emlzLmNvbSIsImlhdCI6MTc2NTU2NjE3MSwiZXhwIjoxNzY2NDMwMTcxfQ.QEJQZfSlcgKLcQT_BZ46pBmRqwz0mHTceV7bDCCXHko';

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getAllEvent,
        token: token,
      );

      if (response.statusCode == 200) {
        // Safe body handling
        Map<String, dynamic> body;
        if (response.body is String) {
          body = jsonDecode(response.body as String);
        } else {
          body = response.body as Map<String, dynamic>;
        }

        final List rawEvents = body["data"]["data"];

        // JSON → Model
        _allEvents =
            rawEvents.map((e) => EventData.fromJson(e)).toList();

        // =========================
        // Extract categories
        // =========================
        _categories = ["All"];
        for (final e in _allEvents) {
          if (e.category != null && e.category!.trim().isNotEmpty) {
            _categories.add(e.category!.trim().capitalize());
          }
        }

        _categories = _categories.toSet().toList()..sort();

        // Default filter
        applyCategoryFilter("All");

        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Failed to fetch events";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _inProgress = false;
    notifyListeners();
    return false;
  }

  // =========================
  // 🔥 Category Filter
  // =========================
  void applyCategoryFilter(String category) {
    _selectedCategory = category;

    if (category == "All") {
      _filteredEvents = List.from(_allEvents);
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

// =========================
// String Extension
// =========================
extension StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
