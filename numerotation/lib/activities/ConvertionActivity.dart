import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/utils/Backup.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/AppTitleWidget.dart';

class ConvertionActivity extends StatefulWidget {
  final List<Contact> contacts;

  const ConvertionActivity(this.contacts, {Key key}) : super(key: key);

  @override
  _ConvertionActivityState createState() => _ConvertionActivityState();
}

class _ConvertionActivityState extends State<ConvertionActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _ctrlSearch = new TextEditingController();

  List<String> _selectedContact = [];

  bool processing = false;
  String textLoading = "...";

  @override
  void initState() {
    convert();
    super.initState();
  }

  Future<void> convert() async {}

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
                                          String normalizePhoneNumber =
                                              PhoneUtils.normalizeNumber(
                                                  phone.value);
                                          bool isValideOldNumber = PhoneUtils
                                              .validateNormalizeOldPhoneNumber(
                                                  normalizePhoneNumber);

                                          dynamic operator =
                                              PhoneUtils.determinateOperator(
                                                  normalizePhoneNumber);

                                          return Row(
                                            children: [
                                              Text(phone.value),
                                              Icon(
                                                CupertinoIcons.arrow_right,
                                                size: 9,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5.0),
                                                margin: EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                  color: PhoneUtils.isNewPhone(
                                                              normalizePhoneNumber) &&
                                                          operator != null
                                                      ? (operator["operator_color"]
                                                              as Color)
                                                          .withOpacity(0.4)
                                                      : (isValideOldNumber
                                                              ? Colors.blue
                                                              : Colors.red)
                                                          .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${operator != null ? operator["operator"] : "Inconnu"}",
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                    Text(
                                                      PhoneUtils.isNewPhone(
                                                              normalizePhoneNumber)
                                                          ? normalizePhoneNumber
                                                          : ((operator != null
                                                                  ? operator[
                                                                      "new_initial"]
                                                                  : "") +
                                                              normalizePhoneNumber),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .check_mark_circled_solid,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                visible: PhoneUtils.isNewPhone(
                                                    normalizePhoneNumber),
                                              )
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
        visible: !widget.contacts.every(
            (e) => e.phones.every((p) => PhoneUtils.isNewPhone(p.value))),
        child: BottomAppBar(
          child: Container(
            height: 50,
            //color: secondaryColor,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, Colors.blueAccent],
              ),
            ),
            child: processing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("$textLoading ...")],
                  )
                : InkWell(
                    child: Row(
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
                    ),
                    onTap: () async {
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
                                        style:
                                            theme.textTheme.headline4.copyWith(
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
                                          Navigator.of(context).pop(false);
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
                          textLoading = "Sauvegarde des contacts à convertir";
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
                          List<Item> items = new List();
                          for (Item i in c.phones) {
                            String normalizePhoneNumber =
                                PhoneUtils.normalizeNumber(i.value);
                            bool isValideOldNumber =
                                PhoneUtils.validateNormalizeOldPhoneNumber(
                                    normalizePhoneNumber);
                            if (isValideOldNumber) {
                              String newPhone =
                                  PhoneUtils.convert(normalizePhoneNumber);
                              i.value = newPhone;
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
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
