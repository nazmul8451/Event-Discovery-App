import 'package:flutter/material.dart';
import 'package:gathering_app/View/Screen/Onboarding_screen/splash_screen.dart';

import 'Screen/Onboarding_screen/get_start_screen.dart';
import 'Screen/Onboarding_screen/interest_screen.dart';
class Gathering extends StatelessWidget {
  const Gathering({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.name,
      routes:{
        SplashScreen.name: (context)=> SplashScreen(),
        GetStartScreen.name: (context)=> GetStartScreen(),
        InterestScreen.name: (context)=> InterestScreen(),
      },
    );
  }
}
