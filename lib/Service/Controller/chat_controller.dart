import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

import 'package:gathering_app/Model/ChatModel.dart';

import 'package:gathering_app/Model/MessageModel.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';

class ChatController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;
  List<ChatModel> _chatList = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  List<ChatModel> get chatList => _chatList;

  Future<String?> createChat(String otherUserId) async {
    // ... existing createChat implementation ...
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      url: Urls.chatUrl(otherUserId),
      body: {}, 
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

  Future<void> getChats() async {
    _inProgress = true;
    notifyListeners();
    
    final response = await NetworkCaller.getRequest(url: Urls.getAllChatsUrl);
    
    _inProgress = false;

    if (response.isSuccess) {
      final rawList = response.body!['data'] as List?;
      if (rawList != null) {
        final authId = AuthController().userId;
        String? currentUserId = authId;
        if (currentUserId == null || currentUserId.isEmpty) {
          final cachedProfile = GetStorage().read<Map<String, dynamic>>('cached_user_profile');
          currentUserId = cachedProfile?['id']?.toString() ?? cachedProfile?['_id']?.toString();
        }

        debugPrint("🔍 getChats - MyID: $currentUserId");

        _chatList = rawList.map((chatData) {
          final participants = chatData['participants'] as List?;
          Map<String, dynamic>? otherUserMap;
          String? otherUserId;
          
          if (participants != null && participants.isNotEmpty) {
              debugPrint("👥 Participants for ${chatData['_id']}: $participants");
              for (var p in participants) {
                  String? pId;
                  if (p is Map<String, dynamic>) {
                      pId = (p['_id'] ?? p['id'])?.toString();
                  } else if (p is String) {
                      pId = p;
                  }
                  
                  // Filter out MY ID to find the OTHER person
                  if (pId != null && 
                      currentUserId != null && 
                      pId.toString().trim() != currentUserId.toString().trim()) {
                      
                      if (p is Map<String, dynamic>) otherUserMap = p;
                      otherUserId = pId;
                      break;
                  }
              }
              
              // Fallback: If still null (maybe I am the only one or ID mismatch), pick the first one anyway
              if (otherUserId == null && participants.isNotEmpty) {
                 final first = participants.first;
                 if (first is Map<String, dynamic>) {
                   otherUserMap = first;
                   otherUserId = (first['_id'] ?? first['id'])?.toString();
                 } else {
                   otherUserId = first.toString();
                 }
              }
          }

          debugPrint("💬 Chat ${chatData['_id']} - OtherID: $otherUserId");

          return ChatModel(
            id: chatData['_id'] ?? chatData['id'],
            otherUserId: otherUserId,
            name: otherUserMap?['name'] ?? 'User',
            imageIcon: otherUserMap?['profileImage'] ?? otherUserMap?['image'] ?? otherUserMap?['avatar'], 
            currentMessage: chatData['lastMessage'] != null ? chatData['lastMessage']['content'] ?? 'Sent an attachment' : 'No messages yet', 
            time: chatData['updatedAt'], 
            status: 'offline', 
            isGroup: false,
          );
        }).toList();
      }
    } else {
      _errorMessage = response.errorMessage;
    }
    notifyListeners();
  }

  List<MessageModel> _messageList = [];
  List<MessageModel> get messageList => _messageList;

  Future<void> getMessages(String chatId) async {
    _inProgress = true;
    notifyListeners();
    
    final response = await NetworkCaller.getRequest(url: Urls.getMessage(chatId));
    
    _inProgress = false;

    if (response.isSuccess) {
      final rawList = response.body!['data'] as List?;
      if (rawList != null) {
        final messages = rawList.map((e) => MessageModel.fromJson(e)).toList();
        // Sort: Newest First (Descending) because we use reverse: true in UI
        messages.sort((a, b) {
           DateTime dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
           DateTime dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
           return dateB.compareTo(dateA);
        });
        _messageList = messages;
      }
    } else {
      _errorMessage = response.errorMessage;
    }
    notifyListeners();
  }

  Future<bool> sendMessage(String chatId, String text) async {
    _inProgress = true; 
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      url: Urls.sendMessage,
      body: {
        "chatId": chatId,
        "text": text,
      },
    );

    _inProgress = false;

    if (response.isSuccess) {
      await getMessages(chatId);
      return true;
    } else {
      _errorMessage = response.errorMessage;
      notifyListeners();
      return false;
    }
  }
}
