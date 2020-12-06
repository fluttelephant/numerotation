import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    if (await Permission.contacts
        .request()
        .isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
        _contactsAll = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey.withOpacity(0.02),
              height: size.height / 4,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.black,
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
                            Theme
                                .of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                              fontSize: 26,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${_contacts != null
                                ? _contacts.length
                                : "Aucun contact"} trouvé(s)",
                            style:
                            Theme
                                .of(context)
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
                            (c.familyName ?? "").toLowerCase().contains(
                                value.toLowerCase()) ||
                                (c.middleName ?? "").toLowerCase().contains(
                                    value.toLowerCase()) ||
                                (c.givenName ?? "").toLowerCase().contains(
                                    value.toLowerCase()) ||
                                (c.displayName ?? "").toLowerCase().contains(
                                    value.toLowerCase()) ||
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
            Expanded(
              child: _contacts != null
              //Build a list view of all contacts, displaying their avatar and
              // display name
                  ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 18),
                      leading: (contact.avatar != null &&
                          contact.avatar.isNotEmpty)
                          ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar),
                      )
                          : CircleAvatar(
                        child: Text(contact.initials()),
                        backgroundColor:
                        Theme
                            .of(context)
                            .accentColor,
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
    );
  }
}
