import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  Center(
                    child: Image.asset(
                      'assets/images/splash_img.png',
                      height: 80.h,
                      width: 80.h,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sign up to discover amazing events',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center, // টেক্সট কেন্দ্রে
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
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap:(){
                                Navigator.pushNamed(context, ForgotPassScreen.name);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF9810FA),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
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
                            text: "Have an account? ",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
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
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 36.h,
      width: 98.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Image.asset(iconImg, height: 15.h, width: 15.h),
      ),
    );
  }
}