import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/utils/Backup.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/AppTitleWidget.dart';
import 'package:flutter_contact/contacts.dart' as flC;
import 'package:url_launcher/url_launcher.dart';

class ConvertionActivity extends StatefulWidget {
  final List<Contact> contacts;

  const ConvertionActivity(this.contacts, {Key key}) : super(key: key);

  @override
  _ConvertionActivityState createState() => _ConvertionActivityState();
}

class _ConvertionActivityState extends State<ConvertionActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Contact> _warningContact = [];

  TextEditingController _ctrlSearch = new TextEditingController();

  List<String> _selectedContact = [];

  bool processing = false;
  bool isActiveSaved = false;
  String textLoading = "...";

  DateTime febrary2021 = DateTime.tryParse("2021-01-31 23:59:00Z");

  @override
  void initState() {
    super.initState();

    getAllContact();
  }

  Future<void> convert(Contact c) async {}

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
                    children: [BackButton(), AppTitleWidget()],
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
                            "${widget.contacts != null ? widget.contacts.length : "Aucun"} Contacts selectionnés",
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
              child: widget.contacts != null
                  //Build a list view of all contacts, displaying their avatar and
                  // display name
                  ? ListView.builder(
                      itemCount: widget.contacts?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = widget.contacts?.elementAt(index);
                        return buildItemInkWell(contact);
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
        visible: !widget.contacts.every(
            (e) => e.phones.every((p) => PhoneUtils.isNewPhone(p.value))),
        child: BottomAppBar(
          child: Container(
            height: 50,
            //color: secondaryColor,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: febrary2021.isBefore(DateTime.now()) || isActiveSaved
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
                    child: febrary2021.isBefore(DateTime.now()) || isActiveSaved
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.capslock_fill,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Enregistrer",
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
                                  "Il est préférable de faire la conversion le 1 février 2021... Veuillez patienter  ",
                                  style: theme.textTheme.headline4.copyWith(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                    onTap: febrary2021.isBefore(DateTime.now()) || isActiveSaved
                        ? () async {
                            //warning

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
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: size.width,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.vertical(
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
                                                  /*Text(
                                                      "Attention la conversion de contact en masse comporte des risque il es préferable de convertir vos contact singulièrement ")*/
                                                  Text(
                                                      "Si vous décidez de continuer à convertir vos contacts sélectionnés vont être remplacés par leurs nouveaux formats."),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /*FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text("Annuler"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),*/
                                              FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                    "Convertir plus tard ( 1 Février 2021 )"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
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
                            if (result != null && !!result) {
                              setState(() {
                                processing = true;
                              });
                              setState(() {
                                textLoading =
                                    "Sauvegarde des contacts à convertir";
                              });
                              await Backup.writeContact(widget.contacts);
                              setState(() {
                                textLoading = "Conversion";
                              });

                              for (Contact c in widget.contacts) {
                                setState(() {
                                  textLoading =
                                      "${c.displayName ?? c.familyName ?? c.givenName ?? c.middleName}";
                                });
                                //check valid identifier
                                checkId:
                                {
                                  try {
                                    final contact =
                                        await flC.Contacts.getContact(
                                            c.identifier);
                                    if (contact != null) {
                                      print(
                                          "--------------------------------------------------------------------------");
                                      print(
                                          "| RT identifier: ${contact.unifiedContactId} VS  ${c.identifier}  |");
                                      print(
                                          "| RT middleName: ${contact.middleName} VS  ${c.middleName}  |");
                                      print(
                                          "| RT familyName: ${contact.familyName} VS  ${c.familyName}  |");
                                      print(
                                          "| RT givenName: ${contact.givenName} VS  ${c.givenName}  |");
                                      print(
                                          "| RT phones length: ${contact.phones.length} VS  ${c.phones.length}  |");
                                      print(
                                          "| RT phones: ${contact.phones.map((e) => "${e.label}:${e.value}").join(",")} VS  ${c.phones.map((e) => "${e.label}:${e.value}").join(",")}  |");
                                      print(
                                          "--------------------------------------------------------------------------");
                                    }
                                    if (contact != null &&
                                        contact.unifiedContactId ==
                                            c.identifier &&
                                        c.phones.length ==
                                            contact.phones.length &&
                                        c.phones.every((cPh) => contact.phones
                                            .any((ctPh) =>
                                                (cPh.value == ctPh.value) &&
                                                (cPh.label == ctPh.label)))) {
                                      print(
                                          "------> OK :::::::> ${contact.displayName ?? contact.familyName ?? contact.givenName ?? contact.middleName}");
                                      print(contact.toString());
                                      print(contact.middleName);
                                      print(contact.familyName);
                                      print(contact.givenName);
                                      print(contact.displayName);
                                      print(contact.unifiedContactId);
                                      print(contact.singleContactId);
                                      print(contact.identifier);
                                      break checkId;
                                    } else {
                                      print("BAD ID ${c.identifier}");
                                      await contactWarning(c, size, theme);
                                      continue;
                                    }
                                  } catch (e) {
                                    print("BAD ID (catch ex) ${c.identifier}");
                                    await contactWarning(c, size, theme);
                                    continue;
                                  }
                                }

                                setState(() {
                                  textLoading =
                                      "${c.displayName ?? c.familyName ?? c.givenName ?? c.middleName}";
                                });
                                List<Item> items = new List();
                                for (Item i in c.phones) {
                                  String normalizePhoneNumber =
                                      PhoneUtils.normalizeNumber(i.value);
                                  bool isValideOldNumber = PhoneUtils
                                      .validateNormalizeOldPhoneNumber(
                                          normalizePhoneNumber);
                                  if (isValideOldNumber) {
                                    String newPhone = PhoneUtils.convert(
                                        normalizePhoneNumber);
                                    i.value = newPhone;
                                  }
                                  if (!items.any((it) =>
                                      it.value
                                          .replaceAll("\u202c", "")
                                          .replaceAll("\u202A", "")
                                          .replaceAll(" ", "")
                                          .trim() ==
                                      i.value
                                          .replaceAll("\u202c", "")
                                          .replaceAll("\u202A", "")
                                          .replaceAll(" ", "")
                                          .trim())) items.add(i);
                                }
                                c.phones = [];
                                c.phones = items;
                                //await ContactsService.deleteContact(c);

                                //verifi identifier

                                dynamic result =
                                    await ContactsService.updateContact(c);
                                print(result.toString());

                                print("---------------BEGIN------------------");
                                print(c.toString());
                                print(c.middleName);
                                print(c.familyName);
                                print(c.givenName);
                                print(c.displayName);
                                print(c.androidAccountName);
                                print(c.androidAccountTypeRaw);
                                print(c.identifier);
                                print("------------->");

                                print("-------------END--------------------");
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
                                                      "Vos contacts ont été convertis à 10 chiffres"),
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
                        // isActiveSaved = !isActiveSaved;
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
                            "${c.displayName ?? c.givenName ?? c.middleName ?? c.familyName} ",
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
                                      color: Colors.blueGrey.withOpacity(0.4)),
                                  child: Text("${c.phones.map(
                                    (Item phone) {
                                      //check if ivorian phone number

                                      String normalizePhoneNumber =
                                          PhoneUtils.normalizeNumber(
                                              phone.value);
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

  Widget buildItemInkWell(Contact contact) {
    bool loadingOperation = false;
    bool maj = false;
    bool fail = false;

    List<Item> phones =
        contact.phones.fold(new List<Item>(), (previousValue, element) {
      if (!previousValue.any((e) =>
          element.label == e.label && //1
         (
             (element.value
                  .replaceAll("\u202c", "")
                  .replaceAll("\u202A", "")
                  .replaceAll(" ", "")
                  .trim() ==
              e.value
                  .replaceAll("\u202c", "")
                  .replaceAll("\u202A", "")
                  .replaceAll(" ", "")
                  .trim()) //2
              ||
          (PhoneUtils.isIvorianPhone(e.value) &&
              PhoneUtils.isIvorianPhone(element.value) &&
              PhoneUtils.normalizeNumber(e.value) ==
                  PhoneUtils.normalizeNumber(element.value) //2'
          )))) {
        previousValue.add(element);
      }
      return previousValue;
    }).toList();

    contact.phones = phones;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                          backgroundColor: Colors.grey.withOpacity(0.49),
                        )
                      : CircleAvatar(
                          child: InkWell(
                            onTap: loadingOperation
                                ? null
                                : () async {
                                    return;
                                    setState(() {
                                      loadingOperation = true;
                                    });
                                    Contact c = contact;
                                    List<Item> items = new List();
                                    for (Item i in c.phones) {
                                      String normalizePhoneNumber =
                                          PhoneUtils.normalizeNumber(i.value);
                                      bool isValideOldNumber = PhoneUtils
                                          .validateNormalizeOldPhoneNumber(
                                              normalizePhoneNumber);
                                      if (isValideOldNumber) {
                                        String newPhone = PhoneUtils.convert(
                                            normalizePhoneNumber);
                                        i.value = newPhone;
                                      }
                                      if (!items.any((it) =>
                                          it.value
                                              .replaceAll("\u202c", "")
                                              .replaceAll("\u202A", "")
                                              .replaceAll(" ", "")
                                              .trim() ==
                                          i.value
                                              .replaceAll("\u202c", "")
                                              .replaceAll("\u202A", "")
                                              .replaceAll(" ", "")
                                              .trim())) items.add(i);
                                    }
                                    c.phones = [];
                                    c.phones = items;
                                    try {
                                      dynamic resultUpdate =
                                          await ContactsService.updateContact(
                                              c);
                                      print(resultUpdate);
                                      dynamic resultForm = await ContactsService
                                          .openExistingContact(c);
                                      print(resultForm);
                                      setState(() {
                                        maj = true;
                                      });
                                      _scaffoldKey.currentState.showSnackBar(
                                          new SnackBar(
                                              content:
                                                  Text("Contact mis à jour")));
                                    } catch (e) {
                                      _scaffoldKey.currentState.showSnackBar(
                                          new SnackBar(
                                              content:
                                                  Text("Contact mis à jour")));
                                    }

                                    setState(() {
                                      loadingOperation = false;
                                    });
                                  },
                            child: loadingOperation
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    child: Row(
                                      children: [CircularProgressIndicator()],
                                    ),
                                  )
                                : Icon(
                                    CupertinoIcons.person,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                          ),
                          backgroundColor: Colors.grey.withOpacity(0.26),
                        ),
                  title: Text(
                    contact.displayName ??
                        contact.familyName ??
                        contact.middleName ??
                        contact.givenName ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      ...contact.phones.map(
                        (Item phone) {
                          //check if ivorian phone number

                          String normalizePhoneNumber =
                              PhoneUtils.normalizeNumber(phone.value);
                          bool isValideOldNumber =
                              PhoneUtils.validateNormalizeOldPhoneNumber(
                                  normalizePhoneNumber);

                          dynamic operator = PhoneUtils.determinateOperator(
                              normalizePhoneNumber);

                          String phoneIv = PhoneUtils.addIndicatifNumber(
                              PhoneUtils.isNewPhone(normalizePhoneNumber)
                                  ? normalizePhoneNumber
                                  : ((operator != null
                                          ? operator["new_initial"]
                                          : "") +
                                      normalizePhoneNumber));

                          return Column(
                            children: [
                              operator != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(phone.value)),
                                        Icon(
                                          CupertinoIcons.arrowtriangle_right,
                                          size: 9,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            margin: EdgeInsets.all(2.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${operator != null ? operator["operator"] : "Inconnu"}",
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: operator != null
                                                            ? operator[
                                                                "operator_color"]
                                                            : Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .check_mark_circled_solid,
                                                          color: Colors.green,
                                                          size: 10,
                                                        ),
                                                      ),
                                                      visible:
                                                          PhoneUtils.isNewPhone(
                                                              normalizePhoneNumber),
                                                    )
                                                  ],
                                                ),
                                                if (PhoneUtils.isNewPhone(
                                                        normalizePhoneNumber) ||
                                                    operator != null)
                                                  Row(
                                                    children: [
                                                      Text("+225"),
                                                      if (PhoneUtils.isNewPhone(
                                                          normalizePhoneNumber))
                                                        Text(
                                                            "${normalizePhoneNumber}"),
                                                      if (!PhoneUtils.isNewPhone(
                                                              normalizePhoneNumber) &&
                                                          operator != null)
                                                        Text(
                                                          "${operator["new_initial"]}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: operator !=
                                                                      null
                                                                  ? operator[
                                                                      "operator_color"]
                                                                  : Colors
                                                                      .black87),
                                                        ),
                                                      if (!PhoneUtils.isNewPhone(
                                                          normalizePhoneNumber))
                                                        Text(
                                                            "${normalizePhoneNumber}"),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              if (contact.phones.toList().indexOf(phone) !=
                                  contact.phones.length - 1)
                                Divider(),
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
      ),
    );
  }

  void getAllContact() {}
}
