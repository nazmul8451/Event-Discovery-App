import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Api service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class SavedEventController extends ChangeNotifier {
  final List<EventData> _savedEvents = [];
  bool _inProgress = false;
  String? _errorMessage;

  List<EventData> get savedEvents => _savedEvents;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  bool isSaved(EventData event) {
    return _savedEvents.any((e) => e.id == event.id);
  }

  /// true = saved, false = removed, null = failed
  Future<bool?> toggleSave(EventData event) async {
    final String eventId = event.id!;

    final bool alreadySaved = _savedEvents.any((e) => e.id == eventId);

    _inProgress = true;
    notifyListeners();

    bool? result;

    if (alreadySaved) {
      // UNSAVE
      final response = await NetworkCaller.deleteRequest(
        Urls.deleteSavedEvent(eventId),
        requireAuth: true,
      );

      if (response.isSuccess) {
        _savedEvents.removeWhere((e) => e.id == eventId);
        result = false;
      }
    } else {
      // SAVE
      final response = await NetworkCaller.postRequest(
        url: Urls.addSaveEvent,
        body: {"event": eventId},
        requireAuth: true,
      );

      if (response.isSuccess) {
        // ⚠️ IMPORTANT → clone না করে id-based add
        _savedEvents.add(event);
        result = true;
      }
    }

    _inProgress = false;
    notifyListeners();
    return result;
  }

  /// App start হলে call করবে
  Future<void> loadMySavedEvents() async {
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      url: Urls.getMySaveEvents,
      requireAuth: true,
    );

    if (response.isSuccess && response.body != null) {
      final List<dynamic> list =
          response.body!['data']['data'] as List<dynamic>;

      _savedEvents.clear();
      _savedEvents.addAll(
        list.map(
          (json) => EventData.fromJson(json['event'] as Map<String, dynamic>),
        ),
      );
    }

    _inProgress = false;
    notifyListeners();
  }
}
