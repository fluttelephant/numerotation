import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/Assets.dart';
import 'package:numerotation/core/Constantes.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/CustomElevetion.dart';

import '../RouterGenerator.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _ctr_phone = new TextEditingController();
  String userPhone = null;
  bool enterNewNumber = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userPhone = App.prefs.getString(storageKey + PREF_USER_PHONE_NUMBER);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
              Divider(
                height: 1,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: userPhone == null || enterNewNumber
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Faites évoluer vos contacts pour rester connecté",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                            color: Colors.black26,
                                          ),
                                    ),
                                    Text(
                                      "Connectez-vous a votre outils de migration",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                            color: primaryColor,
                                            fontSize: 22,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  prefixIcon: Icon(CupertinoIcons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    gapPadding: 0.0,
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  hintText:
                                      "Votre numéro de téléphone (8 chiffre)",
                                  fillColor: secondaryColor.withOpacity(0.02),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.phone,
                                controller: _ctr_phone,
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          // valider le numéro

                                          if (_ctr_phone.text.isEmpty ||
                                              _ctr_phone.text.length < 8) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content:
                                                    Text("Numéro trop court"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          String normalizePhoneNumber =
                                              PhoneUtils.normalizeNumber(
                                                  _ctr_phone.text);

                                          print(normalizePhoneNumber);

                                          bool validatePhone = PhoneUtils
                                              .validateNormalizeOldPhoneNumber(
                                                  normalizePhoneNumber);
                                          print(validatePhone);
                                          if (!validatePhone) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content: Text(
                                                    "Numéro de téléphone invalide"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          dynamic operatorPhone =
                                              PhoneUtils.determinateOperator(
                                                  normalizePhoneNumber);

                                          if (operatorPhone == null) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content:
                                                    Text("Opérateur inconnu"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            new SnackBar(
                                              content: Text(
                                                  operatorPhone["operator"]),
                                              backgroundColor: operatorPhone[
                                                  "operator_color"],
                                            ),
                                          );

                                          App.prefs.setString(
                                              storageKey +
                                                  PREF_USER_PHONE_NUMBER,
                                              normalizePhoneNumber);

                                          ///
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  RouterGenerator.home);
                                        },
                                        child: Text(
                                          "Suivant",
                                          style:
                                              theme.textTheme.button.copyWith(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                child:
                                    Text("Vous avez déjà un némero enrégistré"),
                              ),
                              //userPhone == null,
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          // valider le numéro

                                          if (_ctr_phone.text.isEmpty ||
                                              _ctr_phone.text.length < 8) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content:
                                                    Text("Numéro trop court"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          String normalizePhoneNumber =
                                              PhoneUtils.normalizeNumber(
                                                  _ctr_phone.text);

                                          print(normalizePhoneNumber);

                                          bool validatePhone = PhoneUtils
                                              .validateNormalizeOldPhoneNumber(
                                                  normalizePhoneNumber);
                                          print(validatePhone);
                                          if (!validatePhone) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content: Text(
                                                    "Numéro de téléphone invalide"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          dynamic operatorPhone =
                                              PhoneUtils.determinateOperator(
                                                  normalizePhoneNumber);

                                          if (operatorPhone == null) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              new SnackBar(
                                                content:
                                                    Text("Opérateur inconnu"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            new SnackBar(
                                              content: Text(
                                                  operatorPhone["operator"]),
                                              backgroundColor: operatorPhone[
                                                  "operator_color"],
                                            ),
                                          );

                                          App.prefs.setString(
                                              storageKey +
                                                  PREF_USER_PHONE_NUMBER,
                                              normalizePhoneNumber);

                                          ///
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  RouterGenerator.home);
                                        },
                                        child: Text(
                                          "Continuer avec ${userPhone}",
                                          style:
                                              theme.textTheme.button.copyWith(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    enterNewNumber = true;
                                  });
                                },
                                child: Text("Entrer un nouveau numéro"),
                              )
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
