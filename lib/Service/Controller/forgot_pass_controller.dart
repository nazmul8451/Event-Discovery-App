import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20Service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  String savedEmail = '';
  String? _passwordResetToken;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  String? get passwrodResetToken => _passwordResetToken;

  //saved emial function
  void setEmail(String email) {
    savedEmail = email.trim();
    notifyListeners();
  }

  //forgot password API funtion
  Future<bool> forgotPassword(String email) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    bool isSuccess = false;
    // Save email here also (auto safety)
    savedEmail = email.trim();

    final Map<String, String> requestBody = {"email": email};

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.forgotpassUrl,
        body: requestBody,
      );

      if (response.isSuccess) {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage;
      }
    } catch (e) {
      _errorMessage = "Something went wrong! Please try again.";
    } finally {
      _inProgress = false;
      notifyListeners();
    }

    return isSuccess;
  }

  //Code Submit Api Function
  Future<bool> verifyOTP(String code) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    bool isSuccess = false;

    final Map<String, String> requestBody = {
      "email": savedEmail,
      "oneTimeCode": code,
    };
    print('Your Current Email-$savedEmail');
    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.verifyOtpUrl,
        body: requestBody,

      );

      if (response.isSuccess && response.body != null) {
        isSuccess = true;
        // ekhane token ta save korbo
        final token = response.body?['data']?['token'] as String?;
        if (token != null && token.isNotEmpty) {
          _passwordResetToken = token;
          print("Token saved: $_passwordResetToken");
          isSuccess = true;
        } else {
          _errorMessage = "Token not found in response!";
        }
      } else {
        _errorMessage = response.errorMessage ?? "Invalid OTP";
      }
    } catch (e) {
      _errorMessage = "Failed to verify code!";
    } finally {
      _inProgress = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> forgotNewPassword(String newPass, String confirmPass) async {

    if (_passwordResetToken == null || _passwordResetToken!.isEmpty) {
      _errorMessage = "Session expired! Please try again from beginning.";
      _inProgress = false;
      notifyListeners();
      return false;
    }

    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    bool isSuccess = false;

    final Map<String, String> requestBody = {
      "newPassword": newPass,
      "confirmPassword": confirmPass,
    };

    // এখানে Authorization header-এ টোকেন পাঠানো হচ্ছে

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPassUrl,
        body: requestBody,
        // headers: 
        );

      if (response.isSuccess) {
        isSuccess = true;
        _passwordResetToken = null;
        print("Password reset successful!");
      } else {
        _errorMessage = response.errorMessage ?? "Failed to reset password";
      }
    } catch (e) {
      _errorMessage = "Password reset failed! Try again.";
      debugPrint("Reset Password Error: $e");
    } finally {
      _inProgress = false;
      notifyListeners();
    }

    return isSuccess;
  }
}
