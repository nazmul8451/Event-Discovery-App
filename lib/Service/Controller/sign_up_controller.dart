import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20Service/network_caller.dart';
import 'package:gathering_app/Service/Controller/email_verify_controller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:provider/provider.dart';

class SignUpController extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;


Future<bool> signUp({
  required String email,
  required String name,
  required String password,
  required BuildContext context,     // এটা বাধ্যতামূলক
}) async {
  _inProgress = true;
  _errorMessage = null;
  notifyListeners();

  final body = {"name": name, "email": email, "password": password};

  try {
    final response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: body,
    );

    if (response.isSuccess) {
      // এখন এখানে email সেভ + OTP পাঠাও
      final emailVerifyCtrl = Provider.of<EmailVerifyController>(context, listen: false);

      final otpSent = await emailVerifyCtrl.initializeAndSendOtp(email);

      if (otpSent) {
        return true;           // SignUp + OTP সব সাকসেস
      } else {
        _errorMessage = emailVerifyCtrl.errorMessage;
        return false;
      }
    } else {
      _errorMessage = response.errorMessage ?? "Registration failed";
      return false;
    }
  } catch (e) {
    _errorMessage = "Something went wrong";
    return false;
  } finally {
    _inProgress = false;
    notifyListeners();
  }
}
}