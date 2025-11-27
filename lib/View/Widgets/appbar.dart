import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class common_appbar extends StatelessWidget implements PreferredSizeWidget {
  final String titleName;

  const common_appbar({
    super.key,
    required this.titleName,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: true,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_outlined, color: Color(0xFFCC18CA))),
      title: Text(
        titleName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(70);
}