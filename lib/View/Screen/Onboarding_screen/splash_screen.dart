import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Screen/Onboarding_screen/get_start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future<void> _moveTonextScreen()async{
    print('start splash');
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushNamed(context,GetStartScreen.name);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveTonextScreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:Image.asset('assets/images/splash_img.png',height: 300,),
          ),
        ],
      ),
    );
  }
}
