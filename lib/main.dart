import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gathering_app/Service/Controller/Event_Ticket_Provider.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:gathering_app/Service/Controller/email_verify_controller.dart';
import 'package:gathering_app/Service/Controller/event%20_detailsController.dart';
import 'package:gathering_app/Service/Controller/forgot_pass_controller.dart';
import 'package:gathering_app/Service/Controller/getAllEvent_controller.dart';
import 'package:gathering_app/Service/Controller/log_in_controller.dart';
import 'package:gathering_app/Service/Controller/otp_verify_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/Service/Controller/reivew_controller.dart';
import 'package:gathering_app/Service/Controller/sign_up_controller.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:gathering_app/View/widget_controller/interestScreenController.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'Core/AppRoute/app_route.dart';
import 'View/Screen/Onboarding_screen/splash_screen.dart';
import 'View/Theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
   Stripe.publishableKey = ''; 
  await Stripe.instance.applySettings();
  await AuthController().initialize();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => InterestScreenController()),
        ChangeNotifierProvider(create: (_) => SavedEventController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_) => LogInController()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordController()),
        ChangeNotifierProvider(create: (_) => EmailVerifyController()),
        ChangeNotifierProvider(create: (_) => GetAllEventController()),
        ChangeNotifierProvider(create: (_) => EventDetailsController()),
        ChangeNotifierProvider(create: (_) => ReivewController()),
        ChangeNotifierProvider(create: (_) => OtpVerifyController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_)=> EventTicketProvider()),

      ],
      child: ScreenUtilInit(
        designSize: const Size(439, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,

                debugShowCheckedModeBanner: false,
                title: 'Gathering App',
                theme: ThemeColor.lightMode,
                darkTheme: ThemeColor.darkMode,
                themeMode: themeProvider.themeMode,
                initialRoute: SplashScreen.name,
                routes: AppRoutes.routes,
              );
            },
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
