import 'package:contacts_service/contacts_service.dart';
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

  List<String> _selectedContact = [];

  bool processing = false;
  bool isActiveSaved = false;
  String textLoading = "...";

  DateTime febrary2021 = DateTime.tryParse("2021-02-01 00:00:00Z");

  Future<void> getContacts() async {
    setState(() {
      _contacts = null;
      _selectedContact = [];
      _contactsAll = [];
    });
    if (await Permission.contacts.request().isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      Iterable<Contact> contactsAll = await ContactsService.getContacts(
        withThumbnails: false,
      );
      Iterable<Contact> contacts = contactsAll;
      if (contacts.isNotEmpty) {
        contacts = contacts
            .where((element) =>
                element.phones.isNotEmpty &&
                element.phones.any((phone) =>
                    (phone.value.contains("+225") &&
                        phone.value.replaceAll(" ", "").trim().length == 13) ||
                    (phone.value.contains("00225") &&
                        phone.value.replaceAll(" ", "").trim().length == 14) ||
                    //!phone.value.contains("+") ||
                    phone.value.replaceAll(" ", "").trim().length == 10))
            .toList();
      }
      setState(() {
        _contacts = contacts;
        _contactsAll = contacts;
      });
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
                      BackButton(),
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
              child: _contacts != null && !processing
                  //Build a list view of all contacts, displaying their avatar and
                  // display name
                  ? ListView.builder(
                      itemCount: _contacts?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = _contacts?.elementAt(index);
                        return InkWell(
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 18),
                                  leading: (contact.avatar != null &&
                                          contact.avatar.isNotEmpty)
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(contact.avatar),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.49),
                                        )
                                      : CircleAvatar(
                                          child: Icon(
                                            CupertinoIcons.person_solid,
                                            size: 26,
                                            color: Colors.white,
                                          ),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.26),
                                        ),
                                  title: Text(contact.displayName ??
                                      contact.familyName ??
                                      contact.middleName ??
                                      contact.givenName ??
                                      ''),
                                  subtitle: Column(
                                    children: [
                                      ...contact.phones.map(
                                        (Item phone) {
                                          bool isIvPhoneNumber =
                                              PhoneUtils.isIvorianPhone(
                                                  phone.value);
                                          bool isNewIvPhoneNumber =
                                              PhoneUtils.isIvorianNewPhone(
                                                  phone.value);

                                          String normalizePhoneNumber =
                                              PhoneUtils.normalizeNumber(
                                                  phone.value);
                                          bool isValideOldNumber = PhoneUtils
                                              .validateNormalizeOldPhoneNumber(
                                                  normalizePhoneNumber);

                                          dynamic operator =
                                              PhoneUtils.determinateOperator(
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

                                          return !isIvPhoneNumber || !isNewIvPhoneNumber
                                              ? Row(children: [

                                                ])
                                              : Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      margin:
                                                          EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        color: PhoneUtils
                                                                    .isNewPhone(
                                                                        normalizePhoneNumber) &&
                                                                operator != null
                                                            ? (operator["operator_color"]
                                                                    as Color)
                                                                .withOpacity(
                                                                    0.4)
                                                            : (isValideOldNumber
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .red)
                                                                .withOpacity(
                                                                    0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${operator != null ? operator["operator"] : "Inconnu"}",
                                                            style: TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                          Text("${phoneIv}"),
                                                        ],
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
                          onLongPress: () {
                            setState(() {});
                          },
                          onTap: () {},
                        );
                      },
                    )
                  : Center(
                      child: const CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: _contacts != null,
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
                    children: [Text("$textLoading ...")],
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
                              await Backup.writeContact(_contacts);
                              setState(() {
                                textLoading = "Conversion";
                              });

                              for (Contact c in _contacts) {
                                setState(() {
                                  textLoading =
                                      "${c.displayName ?? c.familyName ?? c.givenName ?? c.middleName}";
                                });
                                List<Item> items = new List();
                                for (Item i in c.phones) {
                                  bool isNewPhoneNumber = PhoneUtils
                                      .isIvorianNewPhone(i.value);
                                  print("${i.value} --> $isNewPhoneNumber");
                                  if(isNewPhoneNumber){
                                    setState(() {
                                      textLoading = "reverse ${i.value}";
                                    });
                                    String normalizePhoneNumber =
                                    PhoneUtils.normalizeNumber(i.value);
                                    String newPhone = PhoneUtils.reverse(
                                        normalizePhoneNumber);
                                    i.value = newPhone;
                                    print("$normalizePhoneNumber --> $newPhone");
                                  }

                                  items.add(i);
                                }
                                c.phones = items;
                                await ContactsService.deleteContact(c);
                                await ContactsService.addContact(c);
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
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.vertical(
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
}
