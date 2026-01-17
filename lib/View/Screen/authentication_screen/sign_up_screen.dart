import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/sign_up_controller.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/verify_account.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:gathering_app/View/Widgets/customSnacBar.dart';
import 'package:provider/provider.dart';
import '../../Theme/theme_provider.dart';
import 'forgot_pass_screen.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //? my textFieldController
  TextEditingController nameController = TextEditingController();
  TextEditingController emialController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isEmailValid = false;

  //-----------------------
  bool _signUpIn_Progress = false;

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
                  Center(
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/splash2.png'
                          : 'assets/images/splash_img.png',
               height: 100.h.clamp(100,100),
                    width: 100.h.clamp(100,100),
                    ),
                  ),
                  SizedBox(height: 10.h),
                
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Create Account',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          AuthTextField(
                            controller: nameController,
                            hintText: 'your name',
                            labelText: 'Name',
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your Name';
                              }
                              return null;
                            },
                          ),
                          AuthTextField(
                            controller: emialController,
                            icon: _isEmailValid ? Icons.check : null,
                            hintText: 'your@email.com',
                            labelText: 'Email',
                            onChanged: (value) {
                              setState(() {
                                _isEmailValid = EmailValidator.validate(value);
                              });
                            },
                            validator: (String? value) {
                              String email = value ?? '';
                              if (EmailValidator.validate(email) == false) {
                                return 'Enter a valid email';
                              } else {
                                return null;
                              }
                            },
                          ),
                          AuthTextField(
                            controller: passController,
                            hintText: '••••••••',
                            labelText: 'Password',
                            isPassword: true,
                            validator: (String? value) {
                              if ((value?.length ?? 0) <= 6) {
                                return 'Enter a valid pasword';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 3.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ForgotPassScreen.name,
                                );
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
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: _signUpIn_Progress
                                ? null
                                : onTapSignUp_button,
                            child: Consumer<ThemeProvider>(
                              builder: (context, controller, child) =>
                                  Container(
                                    height: 56.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFB290FF),
                                          Color(0xFF8063F4),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: _signUpIn_Progress
                                          ? SizedBox(
                                              height: 24.h,
                                              width: 24.h,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : Text(
                                              'Sign up',
                                              style: TextStyle(
                                                fontSize: 14.sp.clamp(14, 16),
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                            ),
                          ),

                          SizedBox(height: 20.h),
                          Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).hintColor,
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
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                text: "Already have an account? ",
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapSignUp_button() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _signUpIn_Progress = true;
    });

    await _signUp();

    if (mounted) {
      setState(() {
        _signUpIn_Progress = false;
      });
    }
  }

  //  sign up api calling
  Future<void> _signUp() async {
    final email = emialController.text.trim();
    final signUpController = Provider.of<SignUpController>(
      context,
      listen: false,
    );

    bool isSuccess = await signUpController.signUp(
      email: emialController.text.trim(),
      name: nameController.text.trim(),
      password: passController.text,
      context: context,
    );

    if (!mounted) return;

    if (isSuccess) {
      _clearTextField();
      showCustomSnackBar(
        context: context,
        message: "Registration successful! Please verify your email",
        isError: false,
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyAccount(
              email: email.trim(),
            ), // trim() যোগ করো + নিশ্চিত করো email empty না
          ),
        );
        print("Email : $email");
      }
    } else {
      showCustomSnackBar(
        context: context,
        message: signUpController.errorMessage ?? "Registration failed",
      );
    }
  }

  void _clearTextField() {
    nameController.clear();
    emialController.clear();
    passController.clear();
  }

  void onTapLogIn_button() {
    Navigator.pushReplacementNamed(context, LogInScreen.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emialController.dispose();
    passController.dispose();
    super.dispose();
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
          height: 18.h,
          width: 18.h,
        ),
      ),
    );
  }
}
