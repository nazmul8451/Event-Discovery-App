import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/log_in_controller.dart';
import 'package:gathering_app/Service/auth/google_auth.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart';
import 'package:gathering_app/View/Screen/authentication_screen/forgot_pass_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/sign_up_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  static const String name = '/log-in';
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
 final GlobalKey<FormState> _f_key = GlobalKey<FormState>();
  bool _signinIn_Progress = false;
  bool isPressed = false;
  //textfromField controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      Form(
                        key: _f_key,
                        child: Column(
                          children: [
                            AuthTextField(
                              controller: emailController,
                              icon: Icons.check,
                              hintText: 'your@email.com',
                              labelText: 'Email',
                              validator: (String? value) {
                                String email = value ?? '';
                                if (EmailValidator.validate(email) == false) {
                                  return 'Enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            AuthTextField(
                              controller: passController,
                              icon: Icons.visibility_off,
                              hintText: '••••••••',
                              labelText: 'Password',
                              isPassword: true,
                              obscureText: true,
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
                              color: const Color(0xFF9810FA),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // SizedBox(
                      //   height: 56.h,
                      //   width: double.infinity,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       gradient: const LinearGradient(
                      //         colors: [
                      //           Color(0xFFB290FF),
                      //           Color(0xFF8063F4),
                      //         ], // Define your gradient colors
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //       ),
                      //     ),
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor:Colors.transparent
                      //       ),
                      //       onPressed: () {},
                      //       child: Text('Log in'),
                      //     ),
                      //   ),
                      // ),

                      // Login Button
                      GestureDetector(
                        onTap: _signinIn_Progress ? null : onTapLoginButton,
                        child: Consumer<ThemeProvider>(
                          builder: (context, controller, child) {
                            bool isDark = controller.isDarkMode;

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 120),
                              height: 56.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isDark ? Colors.grey : Colors.grey,
                                  width: 1.5,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB290FF),
                                    Color(0xFF8063F4),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.15),
                                    offset: Offset(4, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _signinIn_Progress
                                    ? SizedBox(
                                        height: 24.h,
                                        width: 24.h,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        'Log in',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Consumer2<LogInController, ThemeProvider>(
                      //   builder: (context, signUpCtrl, themeCtrl, child) {
                      //     // final progressColor = themeCtrl.isDarkMode
                      //     //     ? Color(0xFFCC18CA)
                      //     //     : const Color(0xFF6A7282);
                      //     return signUpCtrl.inProgress
                      //         ? Center(
                      //             child: CircularProgressIndicator(
                      //               strokeWidth: 2,
                      //             ),
                      //           )
                      //         : GestureDetector(
                      //             onTap: () {
                      //               Navigator.pushNamed(
                      //                 context,
                      //                 BottomNavBarScreen.name,
                      //               );
                      //             },
                      //             child: CustomButton(buttonName: 'Log in'),
                      //           );
                      //   },
                      // ),
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
                            iconImg: 'assets/images/facebook_icon.png',
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

  void onTapLoginButton() async {
    if (!_f_key.currentState!.validate()) {
      return;
    }

    setState(() {
      _signinIn_Progress = true;
    });

    await _Login();

    if (mounted) {
      setState(() {
        _signinIn_Progress = false;
      });
    }
  }

  Future<void> _Login() async {
    final logInController = context.read<LogInController>();

    final bool isSuccess = await logInController.login(
      emailController.text.trim(),
      passController.text.trim(),
      context,
    );

    if (!mounted) return;

    if (!mounted) return;

    if (isSuccess) {
      showCustomSnackBar(
        context: context,
        message: "Login successful! 🎉",
        isError: false,
      );

      // সাকসেস হলে হোমে যাও
      Navigator.pushNamedAndRemoveUntil(
        context,
        BottomNavBarScreen.name,
        (route) => false,
      );
    } else {
      showCustomSnackBar(
        context: context,
        message: logInController.errorMessage ?? "Invalid email or password",
      );
    }
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
      width: 70.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.06) : Colors.white,
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
        child: Image.asset(
          iconImg,
          height: 15.h,
          width: 15.h,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
