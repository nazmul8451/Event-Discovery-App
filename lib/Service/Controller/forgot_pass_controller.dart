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
  String? get passwordResetToken => _passwordResetToken; // টাইপো ঠিক করা

  // Step 1: Send email for password reset (OTP will be sent)
  Future<bool> forgotPassword(String email) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    bool isSuccess = false;
    savedEmail = email.trim(); // Save email for later steps

    final Map<String, dynamic> requestBody = {"email": email.trim()};

    try {
      final response = await NetworkCaller.postRequest(
        url: Urls.forgotpassUrl,
        body: requestBody as Map<String,String>?,
        requireAuth: false,
      );

      if (response.isSuccess) {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to send reset link";
      }
    } catch (e) {
      _errorMessage = "Something went wrong! Please try again.";
    } finally {
      _inProgress = false;
      notifyListeners();
    }

    return isSuccess;
  }

  // Step 2: Verify OTP
  Future<bool> verifyOTP(String code) async {
    if (savedEmail.isEmpty) {
      _errorMessage = "Email not found. Please start again.";
      notifyListeners();
      return false;
    }

    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "email": savedEmail,
      "oneTimeCode": code.trim(),
    };

    print('Verifying OTP for Email: $savedEmail');

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.verifyOtpUrl,
        body: requestBody as Map<String, String>?,
        requireAuth: false,
      );

      if (response.isSuccess && response.body != null) {
        final token = response.body?['data']?['token'] as String?;

        if (token != null && token.isNotEmpty) {
          _passwordResetToken = token;
          print("Password Reset Token saved: $_passwordResetToken");
          return true;
        } else {
          _errorMessage = "Token not received from server";
          return false;
        }
      } else {
        _errorMessage = response.errorMessage ?? "Invalid or expired OTP";
        return false;
      }
    } catch (e) {
      _errorMessage = "Failed to verify OTP. Please try again.";
      debugPrint("OTP Verify Error: $e");
      return false;
    } finally {
      _inProgress = false;
      notifyListeners();
    }
  }

  // Step 3: Reset new password using the token
  Future<bool> forgotNewPassword(String newPass, String confirmPass) async {
    if (_passwordResetToken == null || _passwordResetToken!.isEmpty) {
      _errorMessage = "Session expired! Please request password reset again.";
      notifyListeners();
      return false;
    }

    if (newPass != confirmPass) {
      _errorMessage = "Passwords do not match";
      notifyListeners();
      return false;
    }

    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "newPassword": newPass,
      "confirmPassword": confirmPass,
    };

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPassUrl,
        body: requestBody as Map<String, String>?,
        requireAuth: false,
      );

      if (response.isSuccess) {
        _passwordResetToken = null; // Clear token after successful reset
        print("Password reset successful!");
        return true;
      } else {
        _errorMessage = response.errorMessage ?? "Failed to reset password";
        return false;
      }
    } catch (e) {
      _errorMessage = "Password reset failed! Please try again.";
      debugPrint("Reset Password Error: $e");
      return false;
    } finally {
      _inProgress = false;
      notifyListeners();
    }
  }

  // Optional: Clear data on logout or failure
  void clearData() {
    savedEmail = '';
    _passwordResetToken = null;
    _errorMessage = null;
    notifyListeners();
  }
}
