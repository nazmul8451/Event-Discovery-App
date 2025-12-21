import 'package:flutter/material.dart';
import 'package:gathering_app/Model/userModel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ProfileController extends ChangeNotifier {
  final GetStorage _storage = GetStorage();

  UserProfileModel? _currentUser;
  bool _inProgress = false;
  String? _errorMessage;

  UserProfileModel? get currentUser => _currentUser;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  bool get hasData => _currentUser != null;

  // App start-এ cached profile load

  Future<void> initialize() async {
    final cachedJson = _storage.read<Map<String, dynamic>>(
      'cached_user_profile',
    );
    if (cachedJson != null) {
      _currentUser = UserProfileModel.fromJson(cachedJson);
      notifyListeners();
    }
  }

  // Profile fetch
  Future<bool> fetchProfile({required bool forceRefresh}) async {
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

        print("Full API Response: ${response.body}");

        print("User Data: ${response.body!['data']}");

        _currentUser = UserProfileModel.fromJson(userData);

        // Cache-এ save
        await _storage.write('cached_user_profile', userData);
        await _storage.remove('cached_user_profile');
        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to lad profile";
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

  Future<bool> updateProfile({
    String? name,
    String? description,
    // String? location,
    bool? forceRefresh,
  }) async {
    if (_currentUser == null) return false;

    _inProgress = true;
    notifyListeners();

    try {
      // ⚠️ এই লাইনটা মুছে ফেলো → পুরো ইউজার পাঠানো বন্ধ!
      // Map<String, dynamic> updateData = _currentUser!.toJson();

      // ✅ নতুন করে শুধু দরকারি ফিল্ডগুলোই রাখো
      Map<String, String> updateData = {};

      if (name != null && name.isNotEmpty) {
        updateData['name'] = name.trim();
      }
      if (description != null) {
        updateData['description'] = description.trim();
      }
      // if (location != null && location.isNotEmpty) {
      //   updateData['location'] = location.trim();
      // }
      // যদি description থাকে তাহলে যোগ করো
      // if (description != null) updateData['description'] = description;

      // যদি কোনো ফিল্ডই না দেয়া হয় তাহলে কিছু পাঠাবে না
      if (updateData.isEmpty) {
        _inProgress = false;
        notifyListeners();
        return true; // বা false, যেভাবে চাও
      }

      final response = await NetworkCaller.patchRequest(
        url: Urls.updateProfileUrl,
        body: updateData,
      );

      if (response.isSuccess) {
        // সাকসেস হলে local user আপডেট করো
        final updatedData = response.body!['data'];
        // current user আপডেট করো (শুধু যে ফিল্ডগুলো চেঞ্জ হয়েছে)
        _currentUser = UserProfileModel.fromJson({
          ..._currentUser!.toJson(),
          ...updatedData,
        });
        notifyListeners();
        // ক্যাশেও সেভ করো
        await _storage.write('cached_user_profile', updatedData);
        _inProgress = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Update failed";
        _inProgress = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Update error: $e";
      _inProgress = false;
      notifyListeners();
      return false;
    }
  }

  //   // Clear profile (logout-এ)
  void clear() {
    _currentUser = null;
    _storage.remove('cached_user_profile');
    notifyListeners();
  }
}
