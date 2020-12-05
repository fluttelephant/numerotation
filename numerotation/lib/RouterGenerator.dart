import 'package:flutter/material.dart';
import 'package:numerotation/activities/HomeActivity.dart';
import 'package:numerotation/activities/LoginActivity.dart';
import 'package:numerotation/activities/RegisterActivity.dart';
import 'package:numerotation/activities/SplashScreenActivity.dart';

class RouterGenerator {
  static const splash = '';
  static const intro = 'intro';
  static const start = 'start';
  static const login = 'login';
  static const register = 'register';
  static const forgetPassword = 'forget-password';
  static const home = 'home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    print(settings);
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreenActivity());
      case login:
        return MaterialPageRoute(builder: (_) => LoginActivity());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterActivity());
      case home:
        int position = args == null || !(args is int) ? 0 : args;
        return MaterialPageRoute(builder: (_) => HomeActivity());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreenActivity());
    }
  }
}
