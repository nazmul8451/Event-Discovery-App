import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class common_appbar extends StatelessWidget implements PreferredSizeWidget {
  const common_appbar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
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
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(70);
}