import 'package:flutter/material.dart';
import 'package:gathering_app/Model/notification_model.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class NotificationController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;
  NotificationModel? _notificationModel;
  List<NotificationData> _notifications = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  NotificationModel? get notificationModel => _notificationModel;
  List<NotificationData> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.getRequest(url: Urls.getAllNotificationUrl);

    _inProgress = false;

    if (response.isSuccess) {
      if (response.body != null) {
        _notificationModel = NotificationModel.fromJson(response.body!);
        _notifications = _notificationModel?.data ?? [];
      }
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to load notifications';
    }

    notifyListeners();
  }

  Future<void> fetchNotificationById(String id) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkCaller.getRequest(url: Urls.getNotificationByIdUrl(id));

    _inProgress = false;

    if (response.isSuccess) {
      if (response.body != null) {
        final singleModel = SingleNotificationModel.fromJson(response.body!);
        if (singleModel.data != null) {
          // Update the notification in the list if it exists
          int index = _notifications.indexWhere((n) => n.sId == id);
          if (index != -1) {
            _notifications[index] = singleModel.data!;
          }
        }
      }
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to load individual notification';
    }

    notifyListeners();
  }

  // Adding Mark All As Read as requested by the UI
  Future<bool> markAllAsRead() async {
    // Assuming there's an endpoint for this, but for now just a placeholder
    // If there's no endpoint, we can just update locally if needed
    // Usually, this would be a POST request
    return true; 
  }
}
