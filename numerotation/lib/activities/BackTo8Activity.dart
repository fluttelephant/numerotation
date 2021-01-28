import 'package:contact_editor/contact_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/utils/Backup.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/AppTitleWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class BackTo8Activity extends StatefulWidget {
  const BackTo8Activity({Key key}) : super(key: key);

  @override
  _BackTo8ActivityState createState() => _BackTo8ActivityState();
}

class _BackTo8ActivityState extends State<BackTo8Activity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _ctrlSearch = new TextEditingController();
  List<Contact> _contactsAll;
  List<Contact> _contacts;
  List<Contact> _warningContact = [];

  List<String> _selectedContact = [];

  bool processing = false;
  int indexLoading = -1;
  bool permissionDenied = false;
  bool isActiveSaved = false;
  String textLoading = "...";

  DateTime febrary2021 = DateTime.tryParse("2021-02-01 00:00:00Z");

  Future<void> getContacts() async {
    setState(() {
      indexLoading = -1;
      processing = true;
      _contacts = null;
      _selectedContact = [];
      _contactsAll = [];
    });
    if (await Permission.contacts.request().isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      Iterable<Contact> contactsAll = await ContactEditor.getContacts;
      Iterable<Contact> contacts = contactsAll;
      if (contacts.isNotEmpty) {
        contacts = contacts
            .where((element) =>
                element.phoneList.isNotEmpty &&
                element.phoneList.any((phone) =>
                    (phone.mainData.contains("+225") &&
                        (phone.mainData
                                    .replaceAll(" ", "")
                                    .replaceAll(",", "")
                                    .replaceAll(".", "")
                                    .replaceAll("-", "")
                                    .trim())
                                .length ==
                            14 &&
                        !phone.mainData.contains("\u202c") &&
                        !phone.mainData.contains("\u202A")) ||
                    (phone.mainData.contains("+225") &&
                        (phone.mainData
                                    .replaceAll(" ", "")
                                    .replaceAll(",", "")
                                    .replaceAll(".", "")
                                    .replaceAll("-", "")
                                    .trim())
                                .length ==
                            16 &&
                        phone.mainData.contains("\u202c") &&
                        phone.mainData.contains("\u202A")) ||
                    (phone.mainData.indexOf("00225") == 0 &&
                        (phone.mainData.replaceAll(" ", "").trim()).length ==
                            15) ||
                    //!phone.value.contains("+") ||
                    (phone.mainData
                                .replaceAll(" ", "")
                                .replaceAll(",", "")
                                .replaceAll(".", "")
                                .replaceAll("-", "")
                                .trim()
                                .length ==
                            10 &&
                        !phone.mainData.contains("+") &&
                        phone.mainData.indexOf("00225") != 0 &&
                        !phone.mainData.contains("\u202c") &&
                        !phone.mainData.contains("\u202A")) ||
                    //!phone.value.contains("+") ||
                    (phone.mainData
                                .replaceAll(" ", "")
                                .replaceAll(",", "")
                                .replaceAll(".", "")
                                .replaceAll("-", "")
                                .trim()
                                .length ==
                            12 &&
                        !phone.mainData.contains("+") &&
                        phone.mainData.indexOf("00225") != 0 &&
                        phone.mainData.contains("\u202c") &&
                        phone.mainData.contains("\u202A"))))
            .toList();
      }
      setState(() {
        _contacts = contacts;
        _contactsAll = contacts;

        processing = false;
      });
    } else {
      permissionDenied = true;
    }
  }

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.all(Radius.circular(this.height / 2)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 5.5 * 4.0,
                    offset: Offset(0, 0.5 * 4),
                  ),
                ],
                color: Colors.white,
              ),
              height: size.height / 5,
              padding: EdgeInsets.all(10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: processing
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                      ),
                      Text(
                        "Passe à 8",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.checkmark_shield_fill,
                          color: Colors.red),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_contacts != null ? _contacts.length : "Aucun"} contacts selectionnés",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 22,
                                    ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 5.5 * 4.0,
                              offset: Offset(0, 0.5 * 4),
                            ),
                          ],
                          color: Colors.white.withOpacity(0.03),
                        ),
                        child: Text(
                          "Prenez le temps de verifier les contacts que vous voulez convertir",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 11, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: processing && indexLoading < 0
                  //Build a list view of all contacts, displaying their avatar and
                  // display name
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : _contacts == null || _contacts.length <= 0
                      ? Center(
                          child: Text(
                            "Aucun contact à convertir",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _contacts?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            Contact contact = _contacts?.elementAt(index);

                            return InkWell(
                              child: Container(
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
                                margin: EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 18),
                                        trailing: IconButton(
                                          icon: Center(
                                            child: processing &&
                                                    _contacts
                                                            .indexOf(contact) ==
                                                        indexLoading
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    ],
                                                  )
                                                : Icon(
                                                    Icons.restore,
                                                    size: 26,
                                                    color: Colors.indigo,
                                                  ),
                                          ),
                                          onPressed: processing
                                              ? null
                                              : () async {
                                                  Contact c = contact;
                                                  setState(() {
                                                    processing = true;
                                                    indexLoading = _contacts
                                                        .indexOf(contact);
                                                  });
                                                  setState(() {
                                                    textLoading =
                                                        "Sauvegarde des contacts à convertir";
                                                  });
                                                  //await Backup.writeContact(_contacts);
                                                  setState(() {
                                                    textLoading = "Conversion";
                                                  });

                                                  setState(() {
                                                    textLoading =
                                                        "${c.compositeName ?? c.nameData.firstName ?? c.nameData.middleName ?? c.nameData.surname ?? c.nickName ?? ''}";
                                                  });
                                                  List<PhoneNumber> items =
                                                      new List();
                                                  for (PhoneNumber i
                                                      in c.phoneList) {
                                                    bool isNewPhoneNumber =
                                                        PhoneUtils
                                                            .isIvorianNewPhone(
                                                                i.mainData);
                                                    //print("${i.mainData} --> $isNewPhoneNumber");
                                                    if (isNewPhoneNumber) {
                                                      setState(() {
                                                        textLoading =
                                                            "reverse ${i.mainData}";
                                                      });
                                                      /*String
                                                normalizePhoneNumber =
                                                PhoneUtils
                                                    .normalizeNumber(i.mainData);*/
                                                      String newPhone =
                                                          PhoneUtils.reverse(
                                                              i.mainData);
                                                      i.mainData = newPhone;
                                                    }

                                                    items.add(i);
                                                  }
                                                  c.phoneList = [];
                                                  c.phoneList = items;
                                                  //await ContactsService.deleteContact(c);
                                                  await ContactEditor
                                                      .updateContact(c,
                                                          replaceOld: true);

                                                  getContacts();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(
                                                          new SnackBar(
                                                    content: Text(
                                                        "Opération éffectuée"),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ));
                                                },
                                        ),
                                        title: Text(contact.compositeName ??
                                            contact.nameData.firstName ??
                                            contact.nameData.middleName ??
                                            contact.nameData.surname ??
                                            contact.nickName ??
                                            ''),
                                        subtitle: Column(
                                          children: [
                                            ...contact.phoneList.map(
                                              (PhoneNumber phone) {
                                                //print("------------------ ${contact.compositeName ?? contact.nameData.firstName ?? contact.nameData.middleName ?? contact.nameData.surname ?? contact.nickName ?? ''} ------------------");
                                                //print(phone.mainData);

                                                bool isIvPhoneNumber =
                                                    PhoneUtils.isIvorianPhone(
                                                        phone.mainData);

                                                //print("isIvPhoneNumber $isIvPhoneNumber");
                                                bool isNewIvPhoneNumber =
                                                    PhoneUtils
                                                        .isIvorianNewPhone(
                                                            phone.mainData);

                                                //print("isNewIvPhoneNumber $isNewIvPhoneNumber");
                                                String normalizePhoneNumber =
                                                    PhoneUtils.normalizeNumber(
                                                        phone.mainData);

                                                //print("normalizePhoneNumber $normalizePhoneNumber");

                                                bool isValideOldNumber = PhoneUtils
                                                    .validateNormalizeOldPhoneNumber(
                                                        normalizePhoneNumber);

                                                //print("isValideOldNumber $isValideOldNumber");

                                                dynamic operator = PhoneUtils
                                                    .determinateNewOperator(
                                                        normalizePhoneNumber);

                                                String phoneIv = PhoneUtils
                                                    .addIndicatifNumber(PhoneUtils
                                                            .isNewPhone(
                                                                normalizePhoneNumber)
                                                        ? normalizePhoneNumber
                                                        : ((operator != null
                                                                ? operator[
                                                                    "new_initial"]
                                                                : "") +
                                                            normalizePhoneNumber));

                                                return !isIvPhoneNumber ||
                                                        !isNewIvPhoneNumber
                                                    ? Row(children: [])
                                                    : Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5.0),
                                                              margin: EdgeInsets
                                                                  .all(2.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${operator != null ? operator["operator"] : "Inconnu"}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: PhoneUtils.isNewPhone(normalizePhoneNumber) &&
                                                                              operator !=
                                                                                  null
                                                                          ? (operator["operator_color"]
                                                                              as Color)
                                                                          : (isValideOldNumber
                                                                              ? Colors.blue
                                                                              : Colors.red),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "${phoneIv}",
                                                                        softWrap:
                                                                            false,
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Icon(
                                                            CupertinoIcons
                                                                .arrowtriangle_right,
                                                            size: 9,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              PhoneUtils
                                                                  .reverse(phone
                                                                      .mainData),
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onLongPress: () {
                                setState(() {});
                              },
                              onTap: () {},
                            );
                          },
                        ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: _contacts != null && _contacts.length > 0,
        child: BottomAppBar(
          child: Container(
            height: 50,
            //color: secondaryColor,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: febrary2021.isAfter(DateTime.now()) || isActiveSaved
                    ? [primaryColor, Colors.blueAccent]
                    : [Colors.red, Colors.red[700]],
              ),
            ),
            child: processing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$textLoading ...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                : InkWell(
                    child: febrary2021.isAfter(DateTime.now()) || isActiveSaved
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings_backup_restore,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Revenir à 8 chiffre",
                                style: theme.textTheme.headline4.copyWith(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "Il est préférable de laisser les contacts déjà convertis à 10 chiffres après le 1 février 2021... Tapez deux fois pour activer le bouton d'enregistrement  ",
                                  style: theme.textTheme.headline4.copyWith(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                    onTap: febrary2021.isAfter(DateTime.now()) || isActiveSaved
                        ? () async {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              "Attention !!",
                                              style: theme.textTheme.headline4
                                                  .copyWith(
                                                color: Colors.red[900],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "Si vous décidez de continuer vos contacts sélectionnés vont être remplacés par leurs nouveaux formats."),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text("Annuler"),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text("Continuer"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            if (result != null && !!result) {
                              setState(() {
                                processing = true;
                              });
                              setState(() {
                                textLoading =
                                    "Sauvegarde des contacts à convertir";
                              });
                              //await Backup.writeContact(_contacts);
                              setState(() {
                                textLoading = "Conversion";
                              });

                              for (Contact c in _contacts) {
                                setState(() {
                                  textLoading =
                                      "${c.compositeName ?? c.nameData.firstName ?? c.nameData.middleName ?? c.nameData.surname ?? c.nickName ?? ''}";
                                });

                                //check valid identifier
                                /*checkId:
                                {
                                  try {
                                    final contact =
                                        await flC.Contacts.getContact(
                                            c.identifier);
                                    if (contact != null &&
                                        contact.unifiedContactId ==
                                            c.identifier &&
                                        c.middleName == contact.middleName &&
                                        c.familyName == contact.familyName &&
                                        c.givenName == contact.givenName) {
                                      //print(
                                          "------> OK :::::::> ${contact.displayName ?? contact.familyName ?? contact.givenName ?? contact.middleName}");
                                      //print(contact.toString());
                                      //print(contact.middleName);
                                      //print(contact.familyName);
                                      //print(contact.givenName);
                                      //print(contact.displayName);
                                      //print(contact.unifiedContactId);
                                      //print(contact.singleContactId);
                                      //print(contact.identifier);
                                      break checkId;
                                    } else {
                                      //print("BAD ID ${c.identifier}");
                                      await contactWarning(c, size, theme);
                                      continue;
                                    }
                                  } catch (e) {
                                    //print("BAD ID (catch ex) ${c.identifier}");
                                    await contactWarning(c, size, theme);
                                    continue;
                                  }
                                }*/
                                List<PhoneNumber> items = new List();
                                for (PhoneNumber i in c.phoneList) {
                                  bool isNewPhoneNumber =
                                      PhoneUtils.isIvorianNewPhone(i.mainData);
                                  //print("${i.mainData} --> $isNewPhoneNumber");
                                  if (isNewPhoneNumber) {
                                    /*setState(() {
                                      textLoading = "reverse ${i.mainData}";
                                    });*/
                                    String normalizePhoneNumber =
                                        PhoneUtils.normalizeNumber(i.mainData);
                                    String newPhone = PhoneUtils.reverse(
                                        normalizePhoneNumber);
                                    i.mainData = newPhone;
                                    //print(  "$normalizePhoneNumber --> $newPhone");
                                  }

                                  //phone.value.contains("\u202c") &&
                                  //                         !phone.value.contains("\u202A")
                                  /*if (!items.any((it) =>
                                      it.mainData
                                          .replaceAll("\u202c", "")
                                          .replaceAll("\u202A", "")
                                          .replaceAll(" ", "")
                                          .trim() ==
                                      i.mainData
                                          .replaceAll("\u202c", "")
                                          .replaceAll("\u202A", "")
                                          .replaceAll(" ", "")
                                          .trim()))*/
                                  items.add(i);
                                }
                                c.phoneList = [];
                                c.phoneList = items;
                                //await ContactsService.deleteContact(c);
                                await ContactEditor.updateContact(c,
                                    replaceOld: true);
                              }

                              setState(() {
                                processing = false;
                              });

                              await showDialog(
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      //padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: size.width,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Operation terminée !!",
                                                style: theme.textTheme.headline4
                                                    .copyWith(
                                                  color: Colors.green[900],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "Vos contacts ont été remis à 8 chiffres"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text("Ok"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              Navigator.of(context).pop(true);
                            }
                          }
                        : null,
                    onDoubleTap: () {
                      setState(() {
                        isActiveSaved = !isActiveSaved;
                      });
                    },
                  ),
          ),
        ),
      ),
    );
  }

  contactWarning(Contact c, Size size, ThemeData theme) async {
    _warningContact.add(c);
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          //.withOpacity(0.2),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: size.height * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            //padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Attention !! Vous devez faire la mise à jour de ce contact manuellement.",
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
                            "${c.compositeName ?? c.nameData.firstName ?? c.nameData.middleName ?? c.nameData.surname ?? c.nickName ?? ''} ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700]),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("${c.phoneList.map(
                                    (PhoneNumber phone) {
                                      //check if ivorian phone number

                                      String normalizePhoneNumber =
                                          PhoneUtils.normalizeNumber(
                                              phone.mainData);
                                      return normalizePhoneNumber;
                                    },
                                  ).join(" ;")}"),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              " Ce contact n'a pas d'identifiant valide dans votre carnet d'adresse afin d'éviter d'écraser les données Passe à 10 va ignorer ce contact. Vous devez mettre à jour manuellement le contact."),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
