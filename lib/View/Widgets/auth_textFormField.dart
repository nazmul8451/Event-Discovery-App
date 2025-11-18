import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool obscureText;

  const AuthTextField({
    super.key,
    this.icon,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),

          // main container
          Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Color(0xFF250143)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              // border: Border.all(
              //   color: isDark
              //       ? Colors.white.withOpacity(0.2)
              //       : Colors.grey.shade300,
              //   width: 1.2,
              // ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TextFormField(
              obscureText: obscureText,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16.sp,
              ),
              cursorColor: const Color(0xFFCC18CA),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF515151),
                  fontSize: 15.sp,
                ),
                suffixIcon: icon != null
                    ? Icon(
                  icon,
                  color: isDark ? Colors.white60 : const Color(0xFF515151),
                  size: 22.w,
                )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFCC18CA),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}