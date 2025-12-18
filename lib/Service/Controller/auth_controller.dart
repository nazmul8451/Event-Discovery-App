import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    // এখানে বাগ ফিক্স — null চেক করে isNotEmpty করা
    _isLoggedIn = _accessToken != null && _accessToken!.trim().isNotEmpty;

    debugPrint("🔄 Auth initialized - Logged in: $_isLoggedIn");
    debugPrint("Access Token: ${_accessToken?.substring(0, 20)}..."); // প্রথম ২০ অক্ষর দেখাও

    notifyListeners();
  }

  // লগআউট
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _isLoggedIn = false;

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    debugPrint("🚪 User logged out - Tokens cleared");
    notifyListeners();
  }

  // অপশনাল: টোকেন ম্যানুয়ালি আপডেট করা (refresh token এর জন্য)
  Future<void> updateAccessToken(String newAccessToken) async {
    _accessToken = newAccessToken.trim();
    _isLoggedIn = _accessToken!.isNotEmpty;

    await _storage.write(key: _accessTokenKey, value: _accessToken);

    notifyListeners();
  }
}