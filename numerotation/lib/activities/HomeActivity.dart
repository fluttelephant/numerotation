import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/RouterGenerator.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/CustomElevetion.dart';
import 'package:numerotation/shared/RoundedCheckBox.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Iterable<Contact> _contacts;
  Iterable<Contact> _contactsAll;

  TextEditingController _ctrlSearch = new TextEditingController();

  List<String> _selectedContact = [];

  bool selectionState = false;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      Iterable<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        contacts = contacts.where((element) =>
            element.phones.isNotEmpty &&
            element.phones.any((phone) =>
                phone.value.contains("+225") ||
                phone.value.contains("00225") ||
                //!phone.value.contains("+") ||
                phone.value.replaceAll(" ", "").trim().length == 8));
      }
      setState(() {
        _contacts = contacts;
        _contactsAll = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor.withOpacity(0.1),
        elevation: 0,
        title: Text(
          "PassaDix",
          style: theme.textTheme.headline4.copyWith(
            fontSize: 28,
            color: Colors.black,
          ),
        ),
      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevation(
                            height: 40,
                            child: FlatButton(
                              color: selectionState
                                  ? Colors.red[400]
                                  : primaryColor,
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
                                "${selectionState ? "Annuler" : "Commencer"}",
                                style: theme.textTheme.button.copyWith(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Vos contacts",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 26,
                                      color: primaryColor,
                                    ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${_contacts != null ? _contacts.length : "Aucun contact"} trouvé(s)",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: size.width - 40,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 30),
                            prefixIcon: Icon(CupertinoIcons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 0.0,
                            ),
                            hintText: "Rechercher par nom ou par numéro",
                            fillColor: Colors.blueGrey.withOpacity(0.02),
                            filled: true,
                          ),
                          onChanged: (value) {
                            print("$value");
                            _contacts = null;
                            _contacts = _contactsAll.where((c) =>
                                (c.familyName ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                (c.middleName ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                (c.givenName ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                (c.displayName ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                c.phones.any((p) => p.value.contains(value)));

                            setState(() {});
                          },
                          controller: _ctrlSearch,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: selectionState,
              child: Container(
                width: size.width,
                height: 40,
                color: Colors.grey,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${_selectedContact.length} contact(s) selectionné(s)",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print("_contacts.length : ${_contacts.length}");
                        print(
                            "_selectedContact.length ${_selectedContact.length}");

                        if (_selectedContact.length == _contacts.length) {
                          _selectedContact.clear();
                        } else {
                          _selectedContact.clear();
                          _selectedContact.addAll(
                              _contacts.map((e) => e.identifier).toList());
                        }

                        setState(() {});
                      },
                      child: Text(
                          "${_selectedContact.length != _contacts?.length ?? 0 ? "Tout selectionner" : "déselectionner"}"),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RouterGenerator.exports,
                            arguments: _contacts
                                .where((element) => _selectedContact
                                    .contains(element.identifier))
                                .toList());
                      },
                      child: Text("Exporter"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _contacts != null
                  //Build a list view of all contacts, displaying their avatar and
                  // display name
                  ? ListView.builder(
                      itemCount: _contacts?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = _contacts?.elementAt(index);
                        return InkWell(
                          child: Row(
                            children: [
                              Visibility(
                                visible: selectionState,
                                child: Container(
                                  width: 30,
                                  child: RoundedCheckBox(
                                    onChanged: (value) {
                                      selectedItem(value, contact);
                                    },
                                    value: _selectedContact.indexOf(
                                            contact.identifier.trim()) >=
                                        0,
                                  ),
                                ),
                              ),
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
                                  subtitle: Text(contact.phones.isNotEmpty
                                      ? contact.phones.first.value
                                      : contact.emails.isNotEmpty
                                          ? contact.emails.first.value
                                          : ""),
                                ),
                              ),
                            ],
                          ),
                          onLongPress: () {
                            setState(() {
                              selectionState = !selectionState;
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
      floatingActionButton: Visibility(
        visible: _selectedContact.length > 0 && selectionState,
        child: FloatingActionButton.extended(
          label: Text('Convertir'),
          onPressed: () {
            Navigator.of(context).pushNamed(RouterGenerator.convert,
                arguments: _contacts
                    .where((element) =>
                        _selectedContact.contains(element.identifier))
                    .toList());
          },
          icon: Icon(CupertinoIcons.number),
        ),
      ),
    );
  }

  void selectedItem(value, Contact contact) {
    print("value : $value");
    print("contact.identifier : ${contact.identifier}");
    if (_selectedContact.indexOf(contact.identifier.trim()) >= 0) {
      _selectedContact
          .removeAt(_selectedContact.indexOf(contact.identifier.trim()));
    } else {
      _selectedContact.add(contact.identifier.trim());
    }
    setState(() {});
  }
}
