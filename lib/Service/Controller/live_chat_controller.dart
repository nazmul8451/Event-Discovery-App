import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/Model/live_chat_message_model.dart';

class LiveChatController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<LiveChatMessageModel> _messages = [];
  List<LiveChatMessageModel> get messages => _messages;

  Future<void> fetchMessages(String streamId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getLiveMessageUrl(streamId),
        requireAuth: true,
      );

      if (response.isSuccess && response.body != null) {
        final List<dynamic> data = response.body!['data'] ?? [];
        _messages = data.map((e) => LiveChatMessageModel.fromJson(e)).toList();
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to fetch messages';
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage(String streamId, String message) async {
    _errorMessage = null;
    
    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.sentMessageUrl(streamId),
        body: {'message': message},
        requireAuth: true,
      );

      if (response.isSuccess) {
        // Refresh messages after sending
        await fetchMessages(streamId);
        return true;
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to send message';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> likeMessage(String messageId, String streamId) async {
    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.likeMessageUrl(messageId),
        body: {},
        requireAuth: true,
      );

      if (response.isSuccess) {
        // Refresh messages to update like count and status
        await fetchMessages(streamId);
      }
    } catch (e) {
      print("Error liking message: $e");
    }
  }

  Future<bool> deleteMessage(String messageId, String streamId) async {
    try {
      final response = await NetworkCaller.deleteRequest(
        Urls.deleteMessageUrl(messageId),
        requireAuth: true,
      );

      if (response.isSuccess) {
        await fetchMessages(streamId);
        return true;
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to delete message';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
      notifyListeners();
      return false;
    }
  }
}
