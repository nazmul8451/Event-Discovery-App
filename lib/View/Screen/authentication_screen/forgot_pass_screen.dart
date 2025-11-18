import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/authentication_screen/code_send.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';
import 'package:provider/provider.dart';

import '../../Widgets/appbar.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  static const String name = '/forgot-pass-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: common_appbar(titleName: 'Forgot Password',),
      body: Padding(
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
            AuthTextField(hintText: 'your@email.com', labelText: "Email"),
            SizedBox(height: 20.h),
            GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, CodeSend.name);
                },
                child: CustomButton(buttonName: 'Reset')),
            SizedBox(height: 50.h),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (val) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
