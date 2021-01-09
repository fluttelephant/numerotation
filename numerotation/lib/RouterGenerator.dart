import 'package:contact_editor/contact_editor.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/activities/AboutActivity.dart';
import 'package:numerotation/activities/BackTo8Activity.dart';
import 'package:numerotation/activities/CGUActivity.dart';
import 'package:numerotation/activities/ExportScreenActivity.dart';
import 'package:numerotation/activities/FeaturesListActivity.dart';
import 'package:numerotation/activities/HomeActivity.dart';
import 'package:numerotation/activities/LoginActivity.dart';
import 'package:numerotation/activities/RegisterActivity.dart';
import 'package:numerotation/activities/SplashScreenActivity.dart';

import 'activities/ConvertionActivity.dart';

///
/// A [RouterGenerator]
///
class RouterGenerator {
  static const splash = '';
  static const intro = 'intro';
  static const start = 'start';
  static const login = 'login';
  static const register = 'register';
  static const forgetPassword = 'forget-password';
  static const home = 'home';
  static const backTo8 = 'back-to8';
  static const convert = 'convert';
  static const exports = 'exports';
  static const about = 'about';
  static const cgu = 'cgu';

  static const featuresList = 'features-list';

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
      case backTo8:
         return MaterialPageRoute(builder: (_) => BackTo8Activity());
      case cgu:
         return MaterialPageRoute(builder: (_) => CGUActivity());
      case featuresList:
        return MaterialPageRoute(builder: (_) => FeaturesListActivity());
      case convert:
        List<Contact> contacts = args;
        return MaterialPageRoute(builder: (_) => ConvertionActivity(contacts));
      case about:
         return MaterialPageRoute(builder: (_) => AboutActivity());
      case exports:
        List<Contact> contacts = args;
        return MaterialPageRoute(builder: (_) => ExportScreenActivity(contacts:contacts));
      default:
        return MaterialPageRoute(builder: (_) => SplashScreenActivity());
    }
  }
}
