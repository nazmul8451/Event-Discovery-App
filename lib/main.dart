import 'package:device_preview/device_preview.dart'; // এটা যোগ হবে
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => InterestScreenController()),
        ChangeNotifierProvider(create: (_) => SavedEventController()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(439, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                locale: DevicePreview.locale(context),
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