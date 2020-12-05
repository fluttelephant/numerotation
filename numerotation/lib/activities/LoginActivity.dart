import 'package:flutter/material.dart';

import '../RouterGenerator.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

  Size  size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "LoginActivity",
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.black,
                    ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RouterGenerator.home);
                },
                child: Text("Go"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
