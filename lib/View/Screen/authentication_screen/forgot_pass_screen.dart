import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/forgot_pass_controller.dart';
import 'package:gathering_app/View/Screen/authentication_screen/code_submit.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:provider/provider.dart';
import '../../Widgets/appbar.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  static const String name = '/forgot-pass-screen';

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: common_appbar(titleName: 'Forgot Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot password',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Enter your email address and we will send\nyou a reset instructions.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
              Form(
                key: _formKey,
                child: AuthTextField(
                  controller: emailController,
                  hintText: 'your@email.com',
                  labelText: "Email",
                  validator: (String? value) {
                    String email = value ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return 'Enter a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Consumer<ForgotPasswordController>(
                builder: (context, forgotController, child) {
                  return CustomButton(
                    buttonName: 'Send code',
                    isLoading: forgotController.inProgress,
                    onPressed: onTapSendCodeButton,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapSendCodeButton() async {
    if (_formKey.currentState!.validate()) {
      await forgotPassword_otp();
    }
  }

  Future<void> forgotPassword_otp() async {
    final forgotPassController = Provider.of<ForgotPasswordController>(
      context,
      listen: false,
    );

    bool isSuccess = await forgotPassController.forgotPassword(
      emailController.text.trim(),
    );

    print('Your Current Saved Email-${forgotPassController.savedEmail}');

    if (isSuccess) {
      showCustomSnackBar(
        context: context, 
        message: 'OTP code sent to your email',
        isError: false,
      );
      Navigator.pushNamed(context, CodeSubmit.name);

    } else {
      showCustomSnackBar(context: context, message: 'Something went wrong.please try again');
    }
  }
}
