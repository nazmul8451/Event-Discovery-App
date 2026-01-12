import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool readOnly;

  const AuthTextField({
    super.key,
    this.icon,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.readOnly = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = widget.obscureText || widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),

          // main container
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : widget.obscureText,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16.sp,
            ),
            cursorColor: const Color(0xFFCC18CA),
            decoration: InputDecoration(
              fillColor: isDark ? Color(0xFF250143) : Colors.grey[30],
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF515151),
                fontSize: 14.sp,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF515151),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : (widget.icon != null
                        ? Icon(
                            widget.icon,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF515151),
                            size: 22.w,
                          )
                        : null),
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
        ],
      ),
    );
  }
}
