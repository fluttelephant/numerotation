import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(contact.displayName ??
                      contact.familyName ??
                      contact.middleName ??
                      contact.givenName ??
                      ''),
                );
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
