import 'package:flutter/material.dart';
import 'package:gathering_app/Model/get_all_event_model.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class UserEventController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;
  List<EventData> _userEvents = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  List<EventData> get userEvents => _userEvents;

  Future<bool> fetchUserEvents() async {
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(url: Urls.getUserEventsUrl);

    if (response.isSuccess) {
      try {
        final GetAllEventModel model = GetAllEventModel.fromJson(
          response.body!,
        );
        // Assuming the API returns data in the same structure as GetAllEventModel
        //Adjust parsing if the API structure is different
        if (model.data?.data != null) {
          _userEvents = model.data!.data!;
        } else {
          _userEvents = [];
        }
        _inProgress = false;
        notifyListeners();
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } else {
      _errorMessage = response.errorMessage;
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }
}
