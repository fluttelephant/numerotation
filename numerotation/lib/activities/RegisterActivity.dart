import 'package:flutter/material.dart';

class RegisterActivity extends StatefulWidget {
  @override
  _RegisterActivityState createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Text(
          "RegisterActivity",
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
