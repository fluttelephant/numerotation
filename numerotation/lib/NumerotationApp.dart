import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/theme.dart';

import 'RouterGenerator.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class NumerotationApp extends StatefulWidget {
  @override
  _NumerotationAppState createState() => _NumerotationAppState();
  //good
}

class _NumerotationAppState extends State<NumerotationApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${allTranslations.text("app_name")}',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: allTranslations.supportedLocales(),
      locale: allTranslations.locale,
      theme: _buildThemeData(),
      navigatorObservers: [routeObserver],
      initialRoute: RouterGenerator.login,
      onGenerateRoute: RouterGenerator.generateRoute,
      //debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
    );
  }

  _buildThemeData() {
    return ThemeData(
      //brightness: appTheme.theme.brightness,
      primarySwatch: color2,
      //primarySwatch: color1,
      backgroundColor: whiteLilac,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: "Proxima Nova",
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              headline5: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headline4: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
