import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20Service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  String savedEmail = '';

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

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
      "email": savedEmail, //save email auto asbe
      "oneTimeCode": code, //user input code
    };
    print('Your Current Email-$savedEmail');
    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.verifyOtpUrl,
        body: requestBody,
      );

      if (response.isSuccess) {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage;
      }
    } catch (e) {
      _errorMessage = "Failed to verify code!";
    } finally {
      _inProgress = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> forgotNewPassword(String newPass,String confirmPass) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

        bool isSuccess = false;
    final Map<String, String> requestBody = {
      "newPassword": newPass, 
      "confirmPassword": confirmPass,
    };
        print('Your Current new pass-$newPass');

           try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPassUrl,
        body: requestBody,
      );

      if (response.isSuccess) {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage;
      }
    } catch (e) {
      _errorMessage = "Failed";
    } finally {
      _inProgress = false;
      notifyListeners();
    }
    return isSuccess;

  }
}
