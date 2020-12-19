import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/Assets.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/CustomElevetion.dart';

import '../RouterGenerator.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("res/images/human_evolution.gif"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.0001),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Faites évoluer vos contacts pour rester connecté",
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.black,
                    ),
              ),
              Divider(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Connectez-vous a votre outils de migration ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                      color: primaryColor,
                                      fontSize: 22,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            prefixIcon: Icon(CupertinoIcons.mail),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 0.0,
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            hintText: "Votre adresse mail",
                            fillColor: secondaryColor.withOpacity(0.02),
                            filled: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomElevation(
                                height: 40,
                                child: FlatButton(
                                  color: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        RouterGenerator.home);
                                  },
                                  child: Text(
                                    "Go",
                                    style: theme.textTheme.button.copyWith(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
