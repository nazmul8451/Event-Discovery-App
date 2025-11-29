import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20Service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class SignUpController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;


  Future<bool> signUp(String email, String name, String password) async {
    _inProgress = true;
    _errorMessage = null;
    notifyListeners();

    bool isSuccess = false;

    final Map<String, String> requestBody = {
      "name": name,
      "email": email,
      "password": password,
    };

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl,
        body:requestBody , 
      );

      if (response.isSuccess) {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage ?? "Registration failed";
      }
    } catch (e) {
      _errorMessage = "Something went wrong! Please try again.";
    } finally {
      _inProgress = false;
      notifyListeners();
    }

    return isSuccess;
  }
}