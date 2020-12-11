import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numerotation/model/feature.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../RouterGenerator.dart';

class ImportExportActivity extends StatefulWidget {

  List<Contact> contacts;
  ImportExportActivity({List<Contact> contacts = null})
  {
    this.contacts = contacts;
  }



  @override
  _ImportExportActivityState createState() => _ImportExportActivityState();
}

class _ImportExportActivityState extends State<ImportExportActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Feature> features_import = [];







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    features_import.add(Feature(name: "Importer des contacts", page: RouterGenerator.import));
    features_import.add(Feature(name: "Exporter les contacts"));
  }




  @override
  Widget build(BuildContext context) {

    Size  size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Import Export"),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ListView.builder(
                itemCount: features_import == null ? 0 : features_import.length,
                itemBuilder: (context, index) {
                  var feature = features_import[index];
                  return GestureDetector(
                    onTap: () async {
                      if (feature.page != null) {
                        Navigator.of(context).pushNamed(feature.page);
                      }

                      if(widget.contacts.length >0)
                        {

                          if(feature.name == "Exporter les contacts")
                          {
                            for(int i = 0; i< widget.contacts.length; i++)
                            {
                              await ContactsService.updateContact(widget.contacts[i]);
                            }

                            final snackBar = SnackBar(
                              content: Text('Contacts exportés'),

                            );


                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              widget.contacts = [];
                            });

                          }

                        }


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Text(
                        "${index + 1} - ${feature.name}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),),

              Expanded(
                child: widget.contacts != null
                    ? ListView.builder(
                  itemCount: widget.contacts?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Contact c = widget.contacts?.elementAt(index);


                    return ListTile(
                      selectedTileColor: Colors.deepOrange,
                      onTap: () {
                        print("Selected");





                        /* Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ContactDetailsPage(
                      c,
                      onContactDeviceSave:
                      contactOnDeviceHasBeenUpdated,
                    )));*/
                      },
                      leading: (c.avatar != null && c.avatar.length > 0)
                          ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                          : CircleAvatar(child: Text(c.initials())),
                      title: Text(c.displayName ?? ""),
                    );
                  },
                )
                    : Center(
                  child: Text("No contact selected"),
                )
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
