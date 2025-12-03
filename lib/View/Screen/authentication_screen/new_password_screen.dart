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
                    child: IconButton(onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, ForgotPassScreen.name,(predicate)=> false);
                    }, icon: Icon(Icons.arrow_back)),
                  ),
                  const Spacer(),
                        
              
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Password',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                                labelText: 'New Passwrod',
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
                                  if ((value?.length ?? 0) <= 6) {
                                    return 'Enter a valid pasword';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
              
                  
                        SizedBox(height: 10.h),
              
                        // Login Button
                        Consumer2<LogInController, ThemeProvider>(
                          builder: (context, signUpCtrl, themeCtrl, child) {
                            final progressColor = themeCtrl.isDarkMode
                                ? Color(0xFFCC18CA)
                                : const Color(0xFF6A7282);
                            return signUpCtrl.inProgress
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: progressColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: onTapConfirmButton,
                                    child: CustomButton(buttonName: 'Confirm'),
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
      confirmpassController.text.trim()
      );
    if (isSuccess) {
      showCustomSnackBar(context: context, message: "Congress! Update your password. please Log in your account");
      Navigator.pushReplacementNamed(context, BottomNavBarScreen.name);
    } else {
      showCustomSnackBar(
        context: context,
        message: newPassControll.errorMessage ?? "Opps! Something went wrong..",
      );
    }
  }

}
