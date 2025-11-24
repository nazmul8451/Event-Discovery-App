import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/Onboarding_screen/get_start_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // এটা না থাকলে crash হয়
        Navigator.of(context).pushReplacementNamed(GetStartScreen.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: Image.asset(
             controller.isDarkMode?'assets/images/splash2.png' :'assets/images/splash_img.png',
              height: 300.h,
            ),
          ),
        );
      },
    );
  }
}

