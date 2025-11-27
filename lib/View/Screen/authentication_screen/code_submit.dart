import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Widgets/CustomButton.dart';
import '../../Widgets/appbar.dart';

class CodeSubmit extends StatefulWidget {
  const CodeSubmit({super.key});

  static const String name = '/code-submit';

  @override
  State<CodeSubmit> createState() => _CodeSubmitState();
}

class _CodeSubmitState extends State<CodeSubmit> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController OtpTEController = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: common_appbar(titleName: 'Forgot Password'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code Submit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Enter the 4-Digit code sent to you at\nevent@gmail.com',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            PinCodeTextField(
              backgroundColor: Colors.transparent,
              length: 4,
              obscureText: false,
              animationType: AnimationType.none,
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xFFCC18CA),

              textStyle: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(16.r),
                fieldHeight: 64.h,
                fieldWidth: 64.w,

                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                selectedColor: Colors.transparent,

                activeFillColor: const Color(0xFFCC18CA).withOpacity(0.25),
                selectedFillColor: const Color(0xFFCC18CA).withOpacity(0.35),
                inactiveFillColor: const Color(0xFFCC18CA).withOpacity(0.15),

                borderWidth: 0,
              ),

              enableActiveFill: true,
              boxShadows: const [],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              animationDuration: const Duration(milliseconds: 200),
              controller: OtpTEController,
              appContext: context,

              onChanged: (value) {},
              onCompleted: (value) {
                print("OTP: $value");
              },
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, CodeSend.name);
              },
              child: CustomButton(buttonName: 'Submit'),
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  text: "Don't receive code? ",
                  children: [
                    TextSpan(
                      text: 'Resend Again',
                      style: TextStyle(color: Color(0xFF9810FA)),
                      recognizer: TapGestureRecognizer()
                        ..onTap =ontapResendCode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void ontapResendCode()
  {
    Navigator.pop(context);
  }
}


