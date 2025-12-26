import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ChatController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<String?> createChat(String otherUserId) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      url: Urls.chatUrl(otherUserId),
      body: {}, // Body might be empty as ID is in URL
    );

    _inProgress = false;

    if (response.isSuccess && response.body != null) {
      final data = response.body!['data'];
      if (data != null && data['_id'] != null) {
        notifyListeners();
        return data['_id'];
      }
    } else {
      _errorMessage = response.errorMessage;
    }
    
    notifyListeners();
    return null;
  }
}
