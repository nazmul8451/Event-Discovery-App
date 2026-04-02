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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

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
            hasSeenOnboarding =
                GetStorage().read<bool>('hasSeenOnboarding') ?? false;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  isDark
                      ? 'assets/images/splash2.png'
                      : 'assets/images/splash_img.png',
                  height: 300.h,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
