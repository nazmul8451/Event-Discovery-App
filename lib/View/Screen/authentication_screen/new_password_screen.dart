import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/forgot_pass_controller.dart';
import 'package:gathering_app/Service/Controller/log_in_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart';
import 'package:gathering_app/View/Screen/authentication_screen/code_submit.dart';
import 'package:gathering_app/View/Screen/authentication_screen/forgot_pass_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/sign_up_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class NewPasswordScreen extends StatefulWidget {
  NewPasswordScreen({super.key});

  static const String name = '/new-password-screen';

  bool _signinIn_Progress = false;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  //textfromField controller
  TextEditingController newpassController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 1.sh),
          child: IntrinsicHeight(
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Consumer<ThemeProvider>(
                        builder: (context, controller, child) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              ForgotPassScreen.name,
                              (predicate) => false,
                            );
                          },
                          child: Container(
                            height: 36.r,
                            width: 36.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: controller.isDarkMode
                                  ? const Color(0xFF3E043F)
                                  : const Color(0xFF686868),
                            ),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Password',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),

                        SizedBox(height: 30.h),

                        // TextFields
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthTextField(
                                controller: newpassController,
                                hintText: '••••••••',
                                labelText: 'New Password',
                                obscureText: true,
                                isPassword: true,
                              ),
                              SizedBox(height: 16.h),
                              AuthTextField(
                                controller: confirmpassController,
                                icon: Icons.visibility_off,
                                hintText: '••••••••',
                                labelText: 'Confirm Password',
                                obscureText: true,
                                isPassword: true,
                                validator: (String? value) {
                                  if (value != newpassController.text) {
                                    return 'Passwords do not match';
                                  }
                                  if ((value?.length ?? 0) < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Login Button
                        Consumer<ForgotPasswordController>(
                          builder: (context, forgotController, child) {
                            return CustomButton(
                              buttonName: 'Confirm',
                              isLoading: forgotController.inProgress,
                              onPressed: onTapConfirmButton,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapConfirmButton() async {
    //validate and call api -> go to home screen
    if (_formKey.currentState!.validate()) {
      await createNewPassword();
    }
  }

  Future<void> createNewPassword() async {
    final newPassControll = Provider.of<ForgotPasswordController>(
      context,
      listen: false,
    );

    bool isSuccess = await newPassControll.forgotNewPassword(
      newpassController.text.trim(),
      confirmpassController.text.trim(),
    );
    if (isSuccess) {
      showCustomSnackBar(
        context: context,
        message: "Congratulations! Your password has been updated. Please log in to your account.",
        isError: false,
      );
      Navigator.pushNamedAndRemoveUntil(context, LogInScreen.name, (route) => false);
    } else {
      showCustomSnackBar(
        context: context,
        message: newPassControll.errorMessage ?? "Opps! Something went wrong..",
      );
    }
  }
}
