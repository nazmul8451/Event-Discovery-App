import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart';
import 'package:gathering_app/View/Screen/authentication_screen/forgot_pass_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/sign_up_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  static const String name = '/log-in';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 1.sh),
          child: IntrinsicHeight(
            child: Column(
              children: [
                const Spacer(),

                // Logo
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
                // Welcome Text
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log in to continue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // TextFields
                      const AuthTextField(
                        icon: Icons.check,
                        hintText: 'your@email.com',
                        labelText: 'Email',
                      ),
                      SizedBox(height: 16.h),
                      const AuthTextField(
                        icon: Icons.visibility_off,
                        hintText: '••••••••',
                        labelText: 'Password',
                        obscureText: true,
                      ),

                      // Forgot Password
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
                      SizedBox(height: 10.h),

                      // Login Button
                      CustomButton(
                        onPressed: (){
                          //TODO: Navigate to NabButton after validation and api calling
                          Navigator.pushNamedAndRemoveUntil(context,BottomNavBarScreen.name , (predicate)=>false);
                        },
                          buttonName: 'Login'),

                      SizedBox(height: 30.h),

                      // OR Continue With
                      Center(
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF6A7282),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Social Buttons
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
                      SizedBox(height: 40.h),

                      // Sign Up Text
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            text: "Have an account? ",
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
    );
  }

  void onTapSignUp_button() {
    //TODO: validate user
    //right now navigate log in screen..
    Navigator.pushReplacementNamed(context, SignUpScreen.name);
  }
}

// Social Login Container – Dark Mode Ready
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
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFFE2E8F0),
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
