import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomButton extends StatelessWidget {

  final String buttonName;


  const CustomButton({
    super.key,
    required this.buttonName,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]
      ),
      child: Center(child: Text(
        buttonName,
        style: TextStyle(
          fontSize: 16.sp.clamp(16, 18),
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),),
    );
  }
}
