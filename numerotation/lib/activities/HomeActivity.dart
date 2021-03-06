import 'dart:math';

import 'package:contact_editor/contact_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/NumerotationApp.dart';
import 'package:numerotation/RouterGenerator.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/Constantes.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/RoundedCheckBox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  DateTime febrary2021 = DateTime.tryParse("2021-02-01 00:00:00Z");

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    debugPrint("Nous somme ici ::: ");
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    debugPrint("Nous partons d'ici ::: ");
    getContacts();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Iterable<Contact> _contacts;
  Iterable<Contact> _contactsAll;
  Iterable<Contact> allcontactsAll;

  TextEditingController _ctrlSearch = new TextEditingController();

  List<int> _selectedContact = [];

  bool selectionState = true;
  bool loaindActionProcess = false;

  DateTime now = DateTime.now();

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    setState(() {
      _contacts = null;
      _selectedContact = [];
      _contactsAll = [];
      allcontactsAll = [];
    });
    if (await Permission.contacts.request().isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      List<Contact> contactsAll = await ContactEditor.getContacts;
      Iterable<Contact> contacts = contactsAll;
      if (contacts.isNotEmpty) {
        contacts = contacts.where((element) =>
            element.phoneList.isNotEmpty &&
            element.phoneList
                .any((phone) => PhoneUtils.isIvorianOldPhone(phone.mainData)) &&
            !element.phoneList.every((phone) {
              return element.phoneList.any((p) {
                if (PhoneUtils.isIvorianNewPhone(phone.mainData)) return true;
                bool haveAlreadyAlreadyContactConvert = false;

                haveAlreadyAlreadyContactConvert =
                    PhoneUtils.isIvorianNewPhone(p.mainData) &&
                        PhoneUtils.normalizeNumber(
                                PhoneUtils.reverse(p.mainData)) ==
                            PhoneUtils.normalizeNumber(phone.mainData);

                return haveAlreadyAlreadyContactConvert;
              });
            }));
      }

      print("------------------- ");
      // print(contacts.map((e) => e.identifier).length);
      // print(contacts.map((e) => e.identifier).join("|")+" %%% ");
      setState(() {
        _contacts = contacts;
        _contactsAll = contacts;
        allcontactsAll = contactsAll;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var theme = Theme.of(context);
    String phonesString =
        App.prefs.getString(storageKey + PREF_USER_PHONE_NUMBER);

    //print("phonesString $phonesString ${phonesString.length}");
    List<String> phones = phonesString == null || phonesString.length == 0
        ? []
        : phonesString.split(";");

    List<dynamic> operatorPhone =
        phones.map((e) => PhoneUtils.determinateOperator(e)).toList();

    String name = App.prefs.getString(storageKey + PREF_USER_NAME);

    /*

      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: operatorPhone["operator_color"],
        elevation: 0,
        title: Text(
          allTranslations.text("app_name"),
          style: theme.textTheme.headline4.copyWith(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              //color: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {
                setState(() {
                  selectionState = !selectionState;
                  if (!selectionState) {
                    _selectedContact.clear();
                  }
                });
              },
              child: Text(
                "Partager mon nouveau numéro",
                style: theme.textTheme.button.copyWith(),
              ),
            ),
          ),*/
        ],
      ),

    */

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey[50],
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.all(Radius.circular(this.height / 2)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 5.5 * 4.0,
                      offset: Offset(0, 0.5 * 4),
                    ),
                  ],*/
                  //color: secondaryColor, //Colors.white,
                  //(operatorPhone["operator_color"] as Color), //Colors.white,
                ),
                //height: size.height / 4,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: size.width - 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 30),
                                  prefixIcon: Icon(
                                    CupertinoIcons.search,
                                    size: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 0.0,
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText:
                                      "${allTranslations.text("placeholder_search_input")}",
                                  fillColor: primaryColor.withOpacity(0.1),
                                  filled: true,
                                ),
                                onChanged: (value) {
                                  print("$value");
                                  _contacts = null;
                                  _contacts = _contactsAll.where((c) =>
                                      (c.nameData.firstName ?? "")
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      (c.nameData.middleName ?? "")
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      (c.nameData.surname ?? "")
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      (c.nickName ?? "")
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      c.phoneList.any(
                                          (p) => p.mainData.contains(value)));

                                  setState(() {});
                                },
                                controller: _ctrlSearch,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              decoration: BoxDecoration(
                                  color: secondaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.transparent,
                                  )),
                              alignment: Alignment.center,
                              child: Center(
                                child: Icon(
                                  Icons.more_vert,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                            onTap: () {
                              displayBottomSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: ListTile(
                        onTap: () {
                          getContacts();
                        },
                        leading: CircleAvatar(
                          radius: 42,
                          backgroundColor: primaryColor,
                          child: Center(
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          "$name",
                          style: theme.textTheme.headline6.copyWith(),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "${allcontactsAll != null && allcontactsAll.length > 0 ? allcontactsAll.length : "0"} contacts",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${_contacts != null && _contacts.length > 0 ? _contacts.length : "0"} valides",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    fontSize: 14,
                                    color: secondaryColor,
                                  ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.help,
                                  size: 12,
                                  color: secondaryColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          //.withOpacity(0.2),
                                          contentPadding: EdgeInsets.all(0.0),
                                          content: Container(
                                              height: size.height * 0.25,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              //padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: size.width,
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      color: primaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20.0),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${allTranslations.text("help_contact_valid_title")}",
                                                        style: theme
                                                            .textTheme.headline4
                                                            .copyWith(
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(20),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              "${allTranslations.text("help_valid_contact")}"),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        );
                                      });
                                })
                          ],
                        ),
                        //trailing: Icon(CupertinoIcons.share_solid),
                        contentPadding: EdgeInsets.all(0.0),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 130,
                      padding: EdgeInsets.all(10.0),
                      child: ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,

                        children: [
                          ...operatorPhone.map((opPhone) {
                            String phone =
                                phones[operatorPhone.indexOf(opPhone)];
                            return InkWell(
                              onTap: () {
                                Share.share(
                                    'Bonjour mon ${phone} est désormais ${PhoneUtils.convert(phone)}');
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.092),
                                      blurRadius: 5.5 * 1.0,
                                      offset: Offset(0, 0.5 * 2),
                                    ),
                                  ],
                                  color: Colors.amber.withOpacity(0.4),
                                  gradient: LinearGradient(
                                    colors: [primaryColor, Colors.blueAccent],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${PhoneUtils.addIndicatifNumber(phone)}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      "${PhoneUtils.addIndicatifNumber(PhoneUtils.convert(phone))}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: 14,
                                              color: Colors.black),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.all(
                                        5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.share_solid,
                                          size: 14,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Container(
                            width: 100,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.0002),
                                    blurRadius: 5.5 * 1.0,
                                    offset: Offset(0, 0.5 * 2),
                                  ),
                                ],
                                color: Colors.amber.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [primaryColor, Colors.blueAccent])),
                            child: InkWell(
                              onTap: () {
                                TextEditingController e =
                                    new TextEditingController();
                                bool phoneValide = false;
                                dynamic operator =
                                    {}; // PhoneUtils.determinateOperator(e.text)?["operator"]??["operator"]
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            //.withOpacity(0.2),
                                            contentPadding: EdgeInsets.all(0.0),
                                            content: Container(
                                                height: size.height * 0.40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                //padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: size.width,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              20.0),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${allTranslations.text("label_quick_conversion")}",
                                                          style: theme.textTheme
                                                              .headline4
                                                              .copyWith(
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                prefixIcon: Icon(
                                                                    CupertinoIcons
                                                                        .phone),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  gapPadding:
                                                                      0.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                                ),
                                                                hintText:
                                                                    "${allTranslations.text("placeholder_phone_number_input")}",
                                                                fillColor:
                                                                    secondaryColor
                                                                        .withOpacity(
                                                                            0.02),
                                                                filled: true,
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              controller: e,
                                                              onChanged:
                                                                  (value) {
                                                                setState(
                                                                  () {
                                                                    String
                                                                        normePhone =
                                                                        PhoneUtils
                                                                            .normalizeNumber(
                                                                      e.text,
                                                                    );
                                                                    phoneValide =
                                                                        PhoneUtils.validateNormalizeOldPhoneNumber(
                                                                            normePhone);
                                                                    if (phoneValide) {
                                                                      operator =
                                                                          PhoneUtils.determinateOperator(
                                                                              normePhone);
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Visibility(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: (operator == null || operator["operator_color"] == null
                                                                              ? Colors.blue
                                                                              : (operator["operator_color"] as Color))
                                                                          .withOpacity(
                                                                        0.4,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        10.0,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            3.0),
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                    child: Text(
                                                                      "${operator["operator"]}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            10.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${PhoneUtils.convert(e.text)}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          24,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                3,
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        child:
                                                                            FlatButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "${allTranslations.text("btn_shared_labelle")}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          color:
                                                                              primaryColor,
                                                                          onPressed:
                                                                              () {
                                                                            Share.share('Bonjour ce contact : ${e.text} est désormais ${PhoneUtils.addIndicatifNumber(PhoneUtils.convert(e.text))}');
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                3,
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        child:
                                                                            FlatButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "Appeler",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          color:
                                                                              secondaryColor,
                                                                          onPressed:
                                                                              () async {
                                                                            await launch("tel:${PhoneUtils.addIndicatifNumber(PhoneUtils.convert(e.text))}");
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              visible:
                                                                  phoneValide,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        },
                                      );
                                    });
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(CupertinoIcons.repeat),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                    Text(
                                      "${allTranslations.text("label_quick_conversion")}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(left: 14),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.0002),
                                  blurRadius: 5.5 * 1.0,
                                  offset: Offset(0, 0.5 * 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.deepPurple],
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(RouterGenerator.backTo8);
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(Icons.restore),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Revenir de 10 à 8 chiffres",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "Restauration",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(left: 14),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.0002),
                                  blurRadius: 5.5 * 1.0,
                                  offset: Offset(0, 0.5 * 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                              ),
                            ),
                            child: InkWell(
                              onTap: () async {
                                await showDialogDonation(context, size, theme);
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(Icons.payment),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                    Text(
                                      "Faire un don",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectionState,
                child: Container(
                  width: size.width,
                  height: 40,
                  color: primaryColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${_selectedContact.length} ${allTranslations.text("label_contacts_selected")}",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: FlatButton(
                          onPressed: (loaindActionProcess || _contacts == null)
                              ? null
                              : () async {
                                  selectDeselectall();
                                },
                          child: (loaindActionProcess || _contacts == null)
                              ? Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 2,
                                      child: LinearProgressIndicator(),
                                    )
                                  ],
                                )
                              : Text(
                                  "${_selectedContact.length != _contacts?.length ?? 0 ? allTranslations.text("label_select_all") : allTranslations.text("label_unselect_all")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                ),
                        ),
                      ),
                      if (false)
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            onPressed: _selectedContact.length > 0
                                ? () {
                                    createBackup();
                                  }
                                : null,
                            /*
                          () {
                            Navigator.of(context).pushNamed(
                                RouterGenerator.exports,
                                arguments: _contacts
                                    .where((element) => _selectedContact
                                        .contains(element.identifier))
                                    .toList());
                          },
                          */
                            child: (loaindActionProcess || _contacts == null)
                                ? Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 2,
                                        child: LinearProgressIndicator(),
                                      )
                                    ],
                                  )
                                : Text(
                                    "${allTranslations.text("btn_backup_labelle")}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontSize: 12,
                                          color: _selectedContact.length > 0
                                              ? primaryColor
                                              : Colors.grey,
                                        ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _contacts != null
                    //Build a list view of all contacts, displaying their avatar and
                    // display name
                    ? _contacts.length <= 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_contacts != null && _contacts.length > 0 ? _contacts.length : allTranslations.text("txt_title_no_contact")} ${allTranslations.text("label_found")}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: _contacts?.length ?? 0,
                            padding: EdgeInsets.all(5.0),
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = _contacts?.elementAt(index);

                              List<PhoneNumber> phones = contact.phoneList
                                  .fold(new List<PhoneNumber>(),
                                      (previousValue, element) {
                                if (!previousValue.any((e) =>
                                    element.labelName == e.labelName && //1
                                    ((element.mainData
                                                .replaceAll("(", "")
                                                .replaceAll(")", "")
                                                .replaceAll("-", "")
                                                .replaceAll("\u202c", "")
                                                .replaceAll("\u202A", "")
                                                .replaceAll(" ", "")
                                                .trim() ==
                                            e.mainData
                                                .replaceAll("(", "")
                                                .replaceAll(")", "")
                                                .replaceAll("-", "")
                                                .replaceAll("\u202c", "")
                                                .replaceAll("\u202A", "")
                                                .replaceAll(" ", "")
                                                .trim()) //2
                                        ||
                                        (PhoneUtils.isIvorianPhone(
                                                e.mainData) &&
                                            PhoneUtils.isIvorianPhone(
                                                element.mainData) &&
                                            PhoneUtils.normalizeNumber(
                                                    e.mainData) ==
                                                PhoneUtils.normalizeNumber(
                                                    element.mainData) //2'
                                        )))) {
                                  previousValue.add(element);
                                }
                                return previousValue;
                              }).toList();
                              contact.phoneList = phones;
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.04),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 10,
                                        ),
                                        leading: CircleAvatar(
                                          child: IconButton(
                                            icon: Icon(
                                              CupertinoIcons.phone,
                                              size: 26,
                                              color: Colors.lightBlueAccent,
                                            ),
                                            onPressed: contact.phoneList.isEmpty
                                                ? null
                                                : () async {
                                                    if (contact
                                                            .phoneList.length ==
                                                        1) {
                                                      await call(contact
                                                          .phoneList
                                                          .first
                                                          .mainData);
                                                    } else {
                                                      //open bottom sheet
                                                      displayBottomCallSheet(
                                                          context, contact);
                                                    }
                                                  },
                                          ),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.06),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                contact.compositeName ??
                                                    contact
                                                        .nameData.firstName ??
                                                    contact
                                                        .nameData.middleName ??
                                                    contact.nameData.surname ??
                                                    contact.nickName ??
                                                    '',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(contact.phoneList.isNotEmpty
                                                ? contact
                                                    .phoneList.first.mainData
                                                : contact.emailList.isNotEmpty
                                                    ? contact.emailList.first
                                                        .mainData
                                                    : ""),
                                            Text(
                                              "${contact.phoneList.length} numéro(s)",
                                              style: TextStyle(fontSize: 9),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Visibility(
                                        visible: selectionState,
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                            child: RoundedCheckBox(
                                              onChanged: (value) {
                                                selectedItem(value, contact);
                                              },
                                              value: _selectedContact
                                                  .contains(contact.contactId),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onLongPress: () {
                                        setState(() {
                                          //selectionState = !selectionState;
                                          if (!selectionState) {
                                            _selectedContact.clear();
                                          }
                                        });
                                      },
                                      onTap: () {
                                        if (selectionState) {
                                          selectedItem(selectionState, contact);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                    : Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _selectedContact.length > 0 && selectionState,
        child: FloatingActionButton.extended(
          label: Text(
            '${allTranslations.text("btn_title_convert")}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed(
              RouterGenerator.convert,
              arguments: _contacts
                  .where(
                      (element) => _selectedContact.contains(element.contactId))
                  .toList(),
            );
          },
          icon: Icon(
            CupertinoIcons.number,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future call(String contact) async {
    if (PhoneUtils.isIvorianPhone(contact)) {
      String phone = febrary2021.isBefore(now)
          ? PhoneUtils.addIndicatifNumber(PhoneUtils.convert(contact))
          : contact;
      await launch("tel:${phone}");
    } else {
      await launch("tel:${contact}");
    }
  }

  Future showDialogDonation(
      BuildContext context, Size size, ThemeData theme) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          //.withOpacity(0.2),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: size.height * 0.44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            //padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.deepPurple],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Faire un don !",
                        style: theme.textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Aidez-nous à améliorer nos applications ... Faites un don pour soutenir l'équipe.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "res/images/orangeCI.png",
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Orange Money"),
                                  Text(
                                    "+225${now.isAfter(febrary2021) ? "07" : ""}58018026",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "res/images/moov.jpeg",
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Moov Money"),
                                  Text(
                                    "+225${now.isAfter(febrary2021) ? "01" : ""}02666592",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "res/images/logoMTN.jpg",
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("MTN Money"),
                                  Text(
                                    "+225${now.isAfter(febrary2021) ? "05" : ""}65710326",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
            ),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.41,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Options",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text(
                    "${allTranslations.text("menu_shared_app")}",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  onTap: () {
                    Share.share(
                        '''Partagez Passe à 10 \n Une application pour vous permettre de migrer tous vos contacts au 31 janvier 2021. \nElle est totalement gratuite et ne collecte aucunes de vos données personnelles \n*Cliquez sur le lien pour télécharger*  \nsur google play : https://play.google.com/store/apps/details?id=com.flutter.fute.numerotation \nou sur App store : https://apps.apple.com/us/app/passe-%C3%A0-10/id1547603562 ''');
                  },
                ),
                if (false)
                  ListTile(
                    leading: Icon(Icons.backup),
                    title: Text(
                      "${allTranslations.text("menu_create_backup")}",
                      style: TextStyle(
                        color: _selectedContact.length > 0
                            ? primaryColor
                            : Colors.grey,
                      ),
                    ),
                    onTap: _selectedContact.length > 0
                        ? () {
                            createBackup();
                          }
                        : null,
                  ),
                if (false)
                  ListTile(
                    leading: Icon(Icons.restore),
                    title: Text(
                      "${allTranslations.text("menu_restore_backup")}",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    onTap: () async {
                      //Backup b = new Backup(context);
                      // await b.getBackup();
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.help_center_rounded),
                  title: Text(
                    "Conditions d'utilisations",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushNamed(RouterGenerator.cgu);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_center_outlined),
                  title: Text(
                    "${allTranslations.text("menu_about")}",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushNamed(RouterGenerator.about);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payments_outlined),
                  title: Text(
                    "Faire un don",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  onTap: () async {
                    Size size = MediaQuery.of(context).size;
                    ThemeData theme = Theme.of(context);
                    await showDialogDonation(context, size, theme);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void displayBottomCallSheet(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
            ),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.41,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      contact.compositeName ??
                          contact.nameData.firstName ??
                          contact.nameData.middleName ??
                          contact.nameData.surname ??
                          contact.nickName ??
                          "Quel contact voulez-vous appeler ?",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ...contact.phoneList.map((e) => ListTile(
                      trailing: Icon(CupertinoIcons.phone),
                      title: Text(
                        "${e.mainData}",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                      onTap: () async {
                        await call(e.mainData);
                      },
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> selectDeselectall() async {
    setState(() {
      loaindActionProcess = true;
    });

    if (_selectedContact.length == _contacts.length) {
      _selectedContact.clear();
    } else {
      _selectedContact.clear();
      _selectedContact.addAll(_contacts.map((e) => e.contactId).toList());
    }

    setState(() {
      loaindActionProcess = false;
    });
  }

  void selectedItem(value, Contact contact) {
    //print("value : $value");
    //print("contact.identifier : ${contact.identifier}");
    if (_selectedContact.contains(contact.contactId)) {
      _selectedContact.removeAt(_selectedContact.indexOf(contact.contactId));
    } else {
      _selectedContact.add(contact.contactId);
    }
    setState(() {});
  }

  Future<void> createBackup() async {
    List<Contact> elements = _contacts
        .where((element) => _selectedContact.contains(element.contactId))
        .toList();

    if (elements == null || elements.length < 1) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: Text("${allTranslations.text("select_contacts_to_backup")}"),
        ),
      );
      return;
    }

    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    bool result = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            //.withOpacity(0.2),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
                height: size.height * 0.30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                //padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${allTranslations.text("selected_contact")}",
                          style: theme.textTheme.headline4.copyWith(
                            color: Colors.red[900],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "${allTranslations.text("backup_continuous_text")}"),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Annuler"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Continuer"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });

    if (result != null && result == true) {
      //Backup b = new Backup(context);
      //b.newBackup(elements);
    }
  }
}
