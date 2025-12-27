import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart';
import 'package:gathering_app/View/Screen/Onboarding_screen/get_start_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:get_storage/get_storage.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      final auth = Provider.of<AuthController>(context, listen: false);
      await auth.initialize(); // Ensure tokens are loaded from secure storage
      
      if (auth.isLoggedIn) {
        // User is already logged in, go to Home
        Navigator.of(context).pushReplacementNamed(BottomNavBarScreen.name);
      } else {
        // User not logged in, check if they've seen onboarding
        final hasSeenOnboarding = GetStorage().read<bool>('hasSeenOnboarding') ?? false;
        
        if (hasSeenOnboarding) {
          // Already seen onboarding, go to Login
          Navigator.of(context).pushReplacementNamed(LogInScreen.name);
        } else {
          // New user, show onboarding
          Navigator.of(context).pushReplacementNamed(GetStartScreen.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
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

