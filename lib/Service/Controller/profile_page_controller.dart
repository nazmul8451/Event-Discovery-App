import 'package:flutter/material.dart';
import 'package:gathering_app/Model/userModel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart'; // তোমার Urls file

class ProfileController extends ChangeNotifier {
  final GetStorage _storage = GetStorage();

  UserProfileModel? _currentUser;
  bool _inProgress = false;
  String? _errorMessage;

  UserProfileModel? get currentUser => _currentUser;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  bool get hasData => _currentUser != null;

  // App start-এ cached profile load করো
  Future<void> initialize() async {
    final cachedJson = _storage.read<Map<String, dynamic>>('cached_user_profile');
    if (cachedJson != null) {
      _currentUser = UserProfileModel.fromJson(cachedJson);
      notifyListeners();
    }
  }

  // Profile fetch করো (API থেকে)
  Future<bool> fetchProfile() async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.userProfileUrl,
        requireAuth: true,
      );

      if (response.isSuccess && response.body != null) {
        final userData = response.body!['data'];
        
        _currentUser = UserProfileModel.fromJson(userData);

        // Cache-এ save  (next time app open করলে fast load)
        await _storage.write('cached_user_profile', userData);

        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to load profile";
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "No internet or server error";
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }

  // Profile update করো (optional)
  // Future<bool> updateProfile({
  //   String? name,
  //   String? email,
  //   String? timezone,
  //   Settings? settings,
  // }) async {
  //   if (_currentUser == null) return false;

  //   _inProgress = true;
  //   notifyListeners();

  //   try {
  //     // Update করার জন্য data তৈরি করো
  //     Map<String, dynamic> updateData = _currentUser!.toJson();

  //     if (name != null) updateData['name'] = name;
  //     if (email != null) updateData['email'] = email;
  //     if (timezone != null) updateData['timezone'] = timezone;
  //     if (settings != null) updateData['settings'] = settings.toJson();

  //     final response = await NetworkCaller.putRequest(
  //       url: Urls.updateProfileUrl, // তোমার update endpoint
  //       body: updateData,
  //     );

  //     if (response.isSuccess) {
  //       // Update success → local model + cache update করো
  //       _currentUser = UserProfileModel.fromJson(response.body['data']);
  //       await _storage.write('cached_user_profile', response.body['data']);

  //       _inProgress = false;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _errorMessage = response.errorMessage ?? "Update failed";
  //       _inProgress = false;
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _errorMessage = "Update error";
  //     _inProgress = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Clear profile (logout-এ)
  void clear() {
    _currentUser = null;
    _storage.remove('cached_user_profile');
    notifyListeners();
  }
}