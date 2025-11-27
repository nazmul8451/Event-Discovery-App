// View/app.dart
import 'package:gathering_app/View/Screen/BottomNavBarScreen/booking_confirmed.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/bottom_nav_bar.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/details_screen.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/live_stream.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/notification_screen.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/user_chat_screen.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/view_event_screen.dart';
import 'package:gathering_app/View/Screen/authentication_screen/code_send.dart';
import 'package:gathering_app/View/Screen/authentication_screen/code_submit.dart';
import '../../View/Screen/Onboarding_screen/get_start_screen.dart';
import '../../View/Screen/Onboarding_screen/interest_screen.dart';
import '../../View/Screen/Onboarding_screen/splash_screen.dart';
import '../../View/Screen/authentication_screen/forgot_pass_screen.dart';
import '../../View/Screen/authentication_screen/log_in_screen.dart';
import '../../View/Screen/authentication_screen/sign_up_screen.dart';


class AppRoutes {
  static const String splash = SplashScreen.name;
  static const String getStart = GetStartScreen.name;
  static const String interest = InterestScreen.name;
  static const String login = LogInScreen.name;
  static const String signup = SignUpScreen.name;
  static const String forgotPass = ForgotPassScreen.name;
  static const String codeSend = CodeSend.name;
  static const String codeSubmit = CodeSubmit.name;
  static const String bottomNavBar = BottomNavBarScreen.name;
  static const String notificationScreen = NotificationScreen.name;
  static const String userchatScreen = UserChatScreen.name;
  static const String detaisScreen = DetailsScreen.name;
  static const String bookingConfirmScreen = BookingConfirmedScreen.name;
  static const String viewEventScreen = ViewEventScreen.name;
  static const String liveStream = LiveStream.name;



  static final routes = {
    splash: (context) => const SplashScreen(),
    getStart: (context) => const GetStartScreen(),
    interest: (context) => InterestScreen(),
    login: (context) => const LogInScreen(),
    signup: (context) => const SignUpScreen(),
    forgotPass: (context) => const ForgotPassScreen(),
    codeSend: (context) => const CodeSend(),
    codeSubmit: (context) => const CodeSubmit(),
    bottomNavBar: (context) => const BottomNavBarScreen(),
    notificationScreen: (context) => const NotificationScreen(),
    userchatScreen: (context) =>  UserChatScreen(),
    detaisScreen: (context) => const DetailsScreen(),
    bookingConfirmScreen:(context) => const BookingConfirmedScreen(),
    viewEventScreen:(context) => const ViewEventScreen(),
    liveStream:(context) =>  LiveStream(),

  };
}