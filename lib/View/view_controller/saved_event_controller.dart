import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Api service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class SavedEventController extends ChangeNotifier {
  final List<SavedEventData> _savedEvents = [];
  bool _inProgress = false;
  String? _errorMessage;

  List<SavedEventData> get savedEvents => _savedEvents;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  bool isSaved(EventData event) {
    return _savedEvents.any((e) => e.event.id == event.id);
  }

  /// true = saved, false = removed, null = failed
  Future<bool?> toggleSave(EventData event) async {
    _inProgress = true;
    notifyListeners();

    bool? result;

    try {
      // যদি আগে থেকে saved থাকে
      SavedEventData? savedItem;
      for (var e in _savedEvents) {
        if (e.event.id == event.id) {
          savedItem = e;
          break;
        }
      }

      if (savedItem != null) {
        // DELETE saved event
        final response = await NetworkCaller.deleteRequest(
          Urls.deleteSavedEvent(savedItem.savedId),
          requireAuth: true,
        );

        print("Delete response: ${response.body}");

        if (response.isSuccess &&
            response.body != null &&
            response.body!['success'] == true) {
          _savedEvents.removeWhere((e) => e.event.id == event.id);
          result = false;
        } else {
          result = null;
        }
      } else {
        // SAVE new event
        final response = await NetworkCaller.postRequest(
          url: Urls.addSaveEvent,
          body: {"event": event.id!},
          requireAuth: true,
        );

        print("Save response: ${response.body}");

        if (response.isSuccess &&
            response.body != null &&
            response.body!['success'] == true &&
            response.body!['data'] != null) {
          final newSavedEvent =
              SavedEventData.fromJson(response.body!['data']);
          _savedEvents.add(newSavedEvent);
          result = true;
        } else {
          result = null;
        }
      }
    } catch (e) {
      print("Toggle save error: $e");
      result = null;
    }

    _inProgress = false;
    notifyListeners();
    return result;
  }

  /// App start হলে call করবে
  Future<void> loadMySavedEvents() async {
    _inProgress = true;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getMySaveEvents,
        requireAuth: true,
      );

      if (response.isSuccess && response.body != null) {
        final List<dynamic> list =
            response.body!['data']['data'] as List<dynamic>;

        _savedEvents.clear();
        _savedEvents.addAll(
          list.map((json) => SavedEventData.fromJson(json)),
        );
      }
    } catch (e) {
      print("Load saved events error: $e");
    }

    _inProgress = false;
    notifyListeners();
  }
}

/// SavedEventData new model (SavedEventModel অনুযায়ী)
class SavedEventData {
  final String savedId; // API থেকে আসা savedEvent _id
  final EventData event;

  SavedEventData({required this.savedId, required this.event});

  factory SavedEventData.fromJson(Map<String, dynamic> json) {
    return SavedEventData(
      savedId: json['_id'],
      event: json['event'] is Map<String, dynamic>
          ? EventData.fromJson(json['event'])
          : EventData(id: json['event']), // যদি শুধু event id আসে
    );
  }
}
