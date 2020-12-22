import 'dart:async';

import 'package:flutter/material.dart';

import '../RouterGenerator.dart';

class SplashScreenActivity extends StatefulWidget {
  @override
  _SplashScreenActivity createState() => _SplashScreenActivity();
}

class _SplashScreenActivity extends State<SplashScreenActivity>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _animation = 0.1;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    //AppInit.prefs.remove("$storageKey$storageTokenSuffix");
    // test user phone saved

    //Load profil
    Navigator.of(context).pushReplacementNamed(RouterGenerator.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Text(
          "SplashScreenActivity",
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
