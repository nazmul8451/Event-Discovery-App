
import 'package:flutter/material.dart';
import 'package:gathering_app/Model/userModel.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtherUserProfileController extends ChangeNotifier {
  UserProfileModel? _userProfile;
  bool _inProgress = false;
  String? _errorMessage;

  UserProfileModel? get userProfile => _userProfile;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchUserProfile(String userId) async {
    _inProgress = true;
    _errorMessage = null;
    _userProfile = null; // Clear previous data
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getUserByIdUrl(userId),
        requireAuth: true,
      );

      if (response.isSuccess && response.body != null) {
        final userData = response.body!['data'] as Map<String, dynamic>;
        _userProfile = UserProfileModel.fromJson(userData);
        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to load user profile";
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Error: $e";
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }
}
