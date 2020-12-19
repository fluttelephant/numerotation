import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/RoundedCheckBox.dart';
import 'package:permission_handler/permission_handler.dart';

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
                  ], color: Colors.white),
              height: size.height / 4,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.contacts != null ? widget.contacts.length : "Aucun"} Contacts selectionnés",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 26,
                                    ),
                          )
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
                      )
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
                                                  color: (isValideOldNumber
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
                                                    Text((operator != null
                                                            ? operator[
                                                                "new_initial"]
                                                            : "") +
                                                        normalizePhoneNumber),
                                                  ],
                                                ),
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: secondaryColor,
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enregistrer",
                  style: theme.textTheme.headline4.copyWith(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
