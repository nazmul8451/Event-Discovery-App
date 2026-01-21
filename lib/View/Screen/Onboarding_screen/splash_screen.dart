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
      try {
        // Minimum splash time
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;

        final auth = Provider.of<AuthController>(context, listen: false);
        
        // Use a timeout for safety
        await auth.initialize().timeout(
          const Duration(seconds: 3),
          onTimeout: () => debugPrint("Splash: Auth initialization timed out"),
        );
        
        if (!mounted) return;

        if (auth.isLoggedIn) {
          Navigator.of(context).pushReplacementNamed(BottomNavBarScreen.name);
        } else {
          bool hasSeenOnboarding = false;
          try {
             hasSeenOnboarding = GetStorage().read<bool>('hasSeenOnboarding') ?? false;
          } catch (e) {
            debugPrint("GetStorage error: $e");
          }
          
          if (hasSeenOnboarding) {
            Navigator.of(context).pushReplacementNamed(LogInScreen.name);
          } else {
            Navigator.of(context).pushReplacementNamed(GetStartScreen.name);
          }
        }
      } catch (e) {
        debugPrint("Splash error: $e");
        // Emergency fallback to Login Screen to avoid sticking on splash
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LogInScreen.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Image.asset(
          isDark ? 'assets/images/splash2.png' : 'assets/images/splash_img.png',
          height: 300.h,
        ),
      ),
    );
  }
}

