import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:provider/provider.dart'; // ProfileController import করো

class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String? _accessToken;
  String? _refreshToken;
  bool _isLoggedIn = false;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoggedIn => _isLoggedIn;

  // টোকেন সেভ করা
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken.trim();
    _refreshToken = refreshToken.trim();
    _isLoggedIn = _accessToken!.isNotEmpty;

    await _storage.write(key: _accessTokenKey, value: _accessToken);
    await _storage.write(key: _refreshTokenKey, value: _refreshToken);

    debugPrint("✅ Tokens saved successfully");
    notifyListeners();
  }

  // অ্যাপ স্টার্টে টোকেন লোড করা (অটো লগইন)
  Future<void> initialize() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);

    _isLoggedIn = _accessToken != null && _accessToken!.trim().isNotEmpty;

    debugPrint("🔄 Auth initialized - Logged in: $_isLoggedIn");

    notifyListeners();
  }

  // নতুন: লগইন ফাংশন (email + password দিয়ে)
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context, // ProfileController access করার জন্য
  }) async {
    if (_isLoggedIn) return true; // ইতিমধ্যে লগইন থাকলে

    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.loginUrl, // তোমার urls.dart-এ login endpoint থাকতে হবে
        body: {
          'email': email.trim(),
          'password': password,
        },
        requireAuth: false,
      );

      if (response.isSuccess && response.body != null) {
        // Backend response অনুযায়ী token এক্সট্র্যাক্ট করো
        // নিচের লাইনগুলো তোমার API response structure অনুযায়ী চেঞ্জ করতে পারো
        final Map<String, dynamic> data = response.body!['data'] ?? response.body!;
        final String accessToken = data['accessToken'] ?? data['token'] ?? data['access_token'] ?? '';
        final String refreshToken = data['refreshToken'] ?? data['refresh_token'] ?? '';

        if (accessToken.isEmpty) {
          debugPrint("❌ No access token found in response");
          return false;
        }

        // টোকেন সেভ করো
        await saveTokens(accessToken: accessToken, refreshToken: refreshToken);

        // সবচেয়ে গুরুত্বপূর্ণ: প্রোফাইল ডেটা ফ্রেশ fetch করো
        final profileController = Provider.of<ProfileController>(context, listen: false);
        final bool profileLoaded = await profileController.fetchProfile(forceRefresh: true);

        if (profileLoaded) {
          debugPrint("✅ Login successful + Profile data loaded automatically");
          return true;
        } else {
          debugPrint("⚠️ Login successful but profile load failed");
          return true; // লগইন success, প্রোফাইল পরে লোড হবে
        }
      } else {
        debugPrint("❌ Login API failed: ${response.errorMessage}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Login exception: $e");
      return false;
    }
  }

  // লগআউট
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _isLoggedIn = false;

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    // প্রোফাইল ক্লিয়ার করো (যাতে পুরানো ডেটা না থাকে)
    final profileController = ProfileController(); // বা Provider.of দিয়ে
    profileController.clear();

    debugPrint("🚪 User logged out - Tokens & profile cleared");
    notifyListeners();
  }

  // অপশনাল: নতুন অ্যাক্সেস টোকেন আপডেট (refresh token use করলে)
  Future<void> updateAccessToken(String newAccessToken) async {
    _accessToken = newAccessToken.trim();
    _isLoggedIn = _accessToken!.isNotEmpty;

    await _storage.write(key: _accessTokenKey, value: _accessToken);
    notifyListeners();
  }
}