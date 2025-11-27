import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:provider/provider.dart';

import '../../Theme/theme_provider.dart';
import 'forgot_pass_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1.sh, // maxHeight -> minHeight, কেন্দ্রে রাখার জন্য
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center, // কেন্দ্রীভূত
                children: [
                  Expanded(
                    child: SizedBox(), // উপরের স্পেস
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, controller, child) {
                      return Center(
                        child: Image.asset(
                          controller.isDarkMode
                              ? 'assets/images/splash2.png'
                              : 'assets/images/splash_img.png',
                          height: 80.h,
                          width: 80.h,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sign up to discover amazing events',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        AuthTextField(
                          hintText: 'your name',
                          labelText: 'Name',
                        ),
                        AuthTextField(
                          icon: Icons.check,
                          hintText: 'your@email.com',
                          labelText: 'Email',
                        ),
                        AuthTextField(
                          icon: Icons.remove_red_eye,
                          hintText: '••••••••',
                          labelText: 'Password',
                        ),
                        SizedBox(height: 3.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ForgotPassScreen.name);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFFCC18CA),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        InkWell(
                          onTap: (){
                            onTapSignUp_button();
                          },
                            child: CustomButton(buttonName: 'Sign up')),
                        SizedBox(height: 20.h),
                        Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6A7282),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContinueWithContainer(
                              iconImg: 'assets/images/gmail_icon.png',
                            ),
                            ContinueWithContainer(
                              iconImg: 'assets/images/facebook_icon.png',
                            ),
                            ContinueWithContainer(
                              iconImg: 'assets/images/phone_icon.png',
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            text: "Have an account? ",
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(color: Color(0xFF9810FA)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = onTapLogIn_button,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(), // নিচের স্পেস
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapSignUp_button(){
    //TODO: validate user
    //right now navigate log in screen..
    Navigator.pushReplacementNamed(context, LogInScreen.name);
  }

  void onTapLogIn_button() {
    Navigator.pushReplacementNamed(context, LogInScreen.name);
  }
}
class ContinueWithContainer extends StatelessWidget {
  final String iconImg;
  const ContinueWithContainer({super.key, required this.iconImg});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(right: 12.w),
      height: 36.h,
      width: 98.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(iconImg, height: 15.h, width: 15.h),
      ),
    );
  }
}