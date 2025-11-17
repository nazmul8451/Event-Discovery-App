import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/authentication_screen/forgot_pass_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/sign_up_screen.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  static const String name = '/log-in';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 1.sh,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(),
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
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Log in to continue',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),


                      // TextFormField(
                      //   decoration: InputDecoration(
                      //     hintText: 'email',
                      //     hintStyle: TextStyle(color: Color(0xFF515151)),
                      //     filled: true,
                      //     fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      //
                      //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // এটাই height কমাবে
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      // ),

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
                      CustomButton(buttonName: 'Login'),
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
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(color: Color(0xFF9810FA)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = onTapSignUp_button,
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
    );
  }

  void onTapSignUp_button() {
    Navigator.pushNamed(context, SignUpScreen.name);
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