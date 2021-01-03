import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/Assets.dart';
import 'package:numerotation/core/Constantes.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/CustomElevetion.dart';
import 'package:numerotation/shared/DashedBorder.dart';

import '../RouterGenerator.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _ctr_phone = new TextEditingController();
  TextEditingController ctr_userName = new TextEditingController();
  String userPhone = null;
  String userContactName = null;

  bool enterNewNumber = false;

  int step = 1;

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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Faites évoluer vos contacts pour rester connecté",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      color: Colors.black26,
                                    ),
                          ),
                          Text(
                            "Entrez un pseudonyme et aussi vos propres contacts si vous désirez les partager à vos proches après conversion.",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      color: primaryColor,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: step == 1
                            ? IdentityStepWidget(
                                scaffoldKey: _scaffoldKey,
                                theme: theme,
                                ctr_userName: ctr_userName,
                                userNameChange: (value) {
                                  setState(() {
                                    userContactName = value;
                                    step = 2;
                                  });
                                },
                              )
                            : PhonesStepWidget(
                                userPhoneChange: (value) {
                                  setState(() {
                                    userPhone = value;
                                  });

                                  Navigator.of(context).pushReplacementNamed(
                                      RouterGenerator.home);
                                },
                                scaffoldKey: _scaffoldKey,
                                name: userContactName,
                                theme: theme),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IdentityStepWidget extends StatelessWidget {
  IdentityStepWidget(
      {Key key,
      @required this.userNameChange,
      @required GlobalKey<ScaffoldState> scaffoldKey,
      @required this.theme,
      @required this.ctr_userName})
      : _scaffoldKey = scaffoldKey,
        super(key: key);

  final Function userNameChange;
  final TextEditingController ctr_userName; //= TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              prefixIcon: Icon(CupertinoIcons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                gapPadding: 0.0,
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ),
              hintText:
                  "Votre nom (Visible par vos contacts en cas de partage)",
              fillColor: secondaryColor.withOpacity(0.02),
              filled: true,
            ),
            keyboardType: TextInputType.text,
            controller: ctr_userName,
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
                      // valider le numéro

                      if (ctr_userName.text.isEmpty ||
                          ctr_userName.text.length < 2) {
                        _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                            content: Text("Nom trop court"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      App.prefs.setString(
                          storageKey + PREF_USER_NAME, ctr_userName.text);

                      this.userNameChange(ctr_userName.text);
                    },
                    child: Text(
                      "Suivant",
                      style: theme.textTheme.button.copyWith(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class PhonesStepWidget extends StatefulWidget {
  PhonesStepWidget({
    Key key,
    @required this.userPhoneChange,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required this.theme,
    @required this.name,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final String name;
  final Function userPhoneChange;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ThemeData theme;

  @override
  _PhonesStepWidgetState createState() => _PhonesStepWidgetState();
}

class _PhonesStepWidgetState extends State<PhonesStepWidget> {
  List<TextEditingController> ctr_phones = new List();
  List<FocusNode> myFocusNodes = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TextEditingController _ctr_phone = TextEditingController();
    //ctr_phones.add(_ctr_phone);
    FocusNode fs = new FocusNode();
    myFocusNodes.add(fs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      //height: 2 * MediaQuery.of(context).size.height / 4,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Text(
            "Hello ${widget.name}",
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black26,
                  fontSize: 26,
                ),
          ),
          ...ctr_phones.map(
            (e) {
              int index = ctr_phones.indexOf(e);
              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(CupertinoIcons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        gapPadding: 0.0,
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      hintText:
                          "${allTranslations.text("placeholder_phone_number_input")}",
                      fillColor: secondaryColor.withOpacity(0.02),
                      filled: true,
                      suffixIcon: ctr_phones.indexOf(e) > 0 &&
                              ctr_phones.indexOf(e) == ctr_phones.length - 1
                          ? IconButton(
                              icon: Icon(CupertinoIcons.minus),
                              onPressed: ctr_phones.indexOf(e) > 0
                                  ? () {
                                      print(e.text);

                                      int index = ctr_phones.indexOf(e);
                                      if (index > 0) {
                                        ctr_phones.remove(e);

                                        myFocusNodes.removeAt(index);
                                        //FocusScope.of(context).unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                    }
                                  : null,
                            )
                          : Icon(CupertinoIcons.phone_badge_plus),
                    ),
                    keyboardType: TextInputType.phone,
                    controller: e,
                    focusNode: myFocusNodes[index],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey[300],
                  //style: BorderStyle.values(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text("${allTranslations.text("btn_add_contact")}"),
                ),
              ),
            ),
            onTap: ctr_phones.length < 3
                ? () {
                    if (ctr_phones.length < 3) {
                      TextEditingController _ctr_phone =
                          TextEditingController();

                      ctr_phones.add(_ctr_phone);

                      FocusNode fs = new FocusNode();
                      myFocusNodes.add(fs);

                      setState(() {});
                      fs.requestFocus();
                    }
                  }
                : null,
          ),
          SizedBox(
            height: 30,
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
                      // valider le numéro

                      List<String> phones = new List();

                      for (var controller in ctr_phones) {
                        if (controller.text.isEmpty ||
                            controller.text.length < 8) {
                          widget._scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                              content: Text(
                                  "${allTranslations.text("error_phone_too_short")}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        String normalizePhoneNumber =
                            PhoneUtils.normalizeNumber(controller.text);

                        print(normalizePhoneNumber);

                        bool validatePhone =
                            PhoneUtils.validateNormalizeOldPhoneNumber(
                                normalizePhoneNumber);
                        print(validatePhone);
                        if (!validatePhone) {
                          widget._scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                              content: Text(
                                  "${allTranslations.text("error_invalid_phone")}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        dynamic operatorPhone = PhoneUtils.determinateOperator(
                            normalizePhoneNumber);

                        if (operatorPhone == null) {
                          widget._scaffoldKey.currentState.showSnackBar(
                            // "error_unknown_operator" : "Opérateur inconnu"
                            new SnackBar(
                              content: Text(
                                  "${allTranslations.text("error_unknown_operator")}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        /*widget._scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                            content: Text(operatorPhone["operator"]),
                            backgroundColor: operatorPhone["operator_color"],
                          ),
                        );*/
                        phones.add(normalizePhoneNumber);
                      }

                      App.prefs.setString(storageKey + PREF_USER_PHONE_NUMBER,
                          phones.join(";"));

                      ///
                      this.widget.userPhoneChange(phones.join(";"));
                    },
                    // "btn_next":"Suivant"
                    child: Text(
                      "${allTranslations.text("btn_next")}",
                      style: widget.theme.textTheme.button.copyWith(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNodes.forEach((e) {
      e.dispose();
    });

    super.dispose();
  }
}

class AlreadyPhoneExistWidget extends StatelessWidget {
  final String userPhone;
  final ThemeData theme;

  const AlreadyPhoneExistWidget(
      {Key key, @required this.userPhone, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //"label_already_have_phone": "Vous avez déjà un némero enrégistré"
        Container(
          child: Text("${allTranslations.text("label_already_have_phone")}"),
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
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    // valider le numéro

                    Navigator.of(context)
                        .pushReplacementNamed(RouterGenerator.home);
                  },
                  //"label_continuous_with": "Continuer avec"
                  child: Text(
                    "${allTranslations.text("label_continuous_with")} ${userPhone}",
                    style: theme.textTheme.button.copyWith(),
                  ),
                ),
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
            /*setState(() {
              enterNewNumber = true;
            });*/
          },
          //
          child: Text("${allTranslations.text("btn_enter_number")}"),
        )
      ],
    );
  }
}
