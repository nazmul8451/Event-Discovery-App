import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Widgets/CustomButton.dart';
import 'package:gathering_app/View/Widgets/auth_textFormField.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});
  static const String name = '/forgot-pass-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_outlined, color: Color(0xFFCC18CA))),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: Color(0xFFCC18CA),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot password',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Enter your email address and we will send\nyou a reset instructions.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h,),
              AuthTextField(hintText: 'your@email.com', labelText: "Email"),
              SizedBox(height: 20.h,),
              CustomButton(buttonName: 'Reset')
            ],
          ),
        ),
      ),
    );
  }
}
