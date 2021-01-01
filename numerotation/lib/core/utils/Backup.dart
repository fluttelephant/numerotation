import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io' as io;

class Backup {
  final BuildContext context;
  List<File> backupfiles = new List();

  Backup(this.context);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    DateTime dt = DateTime.now();

    return File('$path/numerotation_${dt.millisecondsSinceEpoch}.data');
  }

  static writeContact(List<Contact> allcontactsAll) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    DateTime dt = DateTime.now();

    //return
    final file = File('$path/numerotation_conversion_${dt.millisecondsSinceEpoch}.data');

    String jsonString;
    List<Map> contacts = new List();
    for (var c in allcontactsAll) {
      contacts.add(c.toMap());
      await Future.delayed(Duration(milliseconds: 300));
    }
    jsonString = json.encode(contacts);

    print(jsonString);
    await file.writeAsString('$jsonString');
  }

  Stream<Contact> contactStream(List<Contact> allcontactsAll) async* {
    final file = await _localFile;

    String jsonString;
    List<Map> contacts = new List();
    for (var c in allcontactsAll) {
      yield c;
      //sleep(Duration(seconds: 1));
      //setState(() {});
      contacts.add(c.toMap());
      await Future.delayed(Duration(milliseconds: 300));
    }
    jsonString = json.encode(contacts);

    print(jsonString);
    file.writeAsString('$jsonString');
  }

  Stream<List<FileSystemEntity>> readFileContactStream() async* {
    final path = await _localPath;
    print(path);
    List files = new List();
    files = io.Directory("$path")
        .listSync()
        .where((element) => element.path.contains("numerotation_"))
        .toList(); //use your folder name insted of resume.
    print(files);
    yield files;
  }

  Stream<List<Contact>> getBackupFileContentStream(FileSystemEntity f) async* {
    /*final path = await _localPath;
    print(path);
    List files = new List();
    files = io.Directory("$path")
        .listSync()
        .where((element) => element.path.contains("numerotation_"))
        .toList(); //use your folder name insted of resume.
    print(files);
    yield files;*/
    File file = File(f.absolute.path);
    String contents = await file.readAsString();
    List<dynamic> mapList = json.decode(contents);

    List<Contact> contacts = new List();
    for (dynamic c in mapList) {
      //yield c;
      //sleep(Duration(seconds: 1));
      //setState(() {});
      c["avatar"] = Uint8List.fromList(c["avatar"].cast<int>());
      Contact contact = Contact.fromMap(c);

      contacts.add(contact);
      await Future.delayed(Duration(milliseconds: 300));
    }
    yield contacts;
  }

  Future<File> getBackup() async {
    print("test");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return StreamBuilder<List<FileSystemEntity>>(
              stream: readFileContactStream(),
              builder: (context, snapshot) {
                return new AlertDialog(
                  backgroundColor: Colors.transparent,
                  //title: new Text("Material Dialog"),
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(20.0)),
                    ),
                    height: MediaQuery.of(context).size.height *
                        (snapshot.hasData && snapshot.data != null
                            ? 0.6
                            : 0.26),
                    width: MediaQuery.of(context).size.height *
                        (snapshot.hasData && snapshot.data != null
                            ? 0.9
                            : 0.26),
                    padding: EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: Center(
                                    child: !snapshot.hasData
                                        ? CircularProgressIndicator()
                                        : Icon(
                                            Icons.check,
                                            size: 40,
                                            color: secondaryColor,
                                          )),
                              )
                            ],
                          ),
                          !snapshot.hasData
                              ? Text(
                                  // "files_loading": "Chargement des fichiers"
                                  "${allTranslations.text("files_loading")}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                )
                              : Text(
                                  //
                                  " ${snapshot.data.length} ${allTranslations.text("backup_files")}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                          Divider(),
                          if (snapshot.hasData && snapshot.data.length > 0)
                            ...snapshot.data.map((f) {
                              String name = f.absolute.path.split("/").last;
                              int timeStamp = int.parse(
                                  (name.split(".").first).split("_").last);
                              DateTime dt =
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      timeStamp,
                                      isUtc: true);

                              DateFormat formatter =
                                  DateFormat.yMMMMEEEEd("fr_FR").add_Hms();
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text("${name.split(".").first}"),
                                    subtitle: Text(
                                        "Sauvegarde de ${formatter.format(dt)}"),
                                    trailing: IconButton(
                                      icon: Icon(Icons.backup),
                                      onPressed: () {
                                        //Show dialog details

                                        showDialogBackupfileContent(f);
                                      },
                                    ),
                                    dense: true,
                                  ),
                                  Divider(),
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ),
                  /* */
                );
              });
        },
      );
    });
  }

  Future<File> newBackup(List<Contact> allcontactsAll) async {
    //final file = await _localFile;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return StreamBuilder<Contact>(
            stream: contactStream(allcontactsAll),
            builder: (context, snapshot) {
              return new AlertDialog(
                backgroundColor: Colors.transparent,
                //title: new Text("Material Dialog"),
                content: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.26,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: Center(
                                child: !snapshot.hasData ||
                                        (snapshot.hasData &&
                                            snapshot.data != null &&
                                            allcontactsAll
                                                    .indexOf(snapshot.data) <
                                                allcontactsAll.length - 1)
                                    ? CircularProgressIndicator()
                                    : Icon(
                                        Icons.check,
                                        size: 40,
                                        color: secondaryColor,
                                      )),
                          )
                        ],
                      ),
                      !snapshot.hasData ||
                              (snapshot.hasData &&
                                  snapshot.data != null &&
                                  allcontactsAll.indexOf(snapshot.data) <
                                      allcontactsAll.length - 1)
                          ? Text(
                              "conversion de ${snapshot.hasData && snapshot.data != null ? snapshot.data.displayName ?? snapshot.data.middleName : ""}",
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            )
                          : Text(
                              //"backup_successfull" : "Sauvergarde créer avec succès
                              "${allTranslations.text("backup_success_full")}",
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                      Visibility(
                        child: Container(
                          height: 65,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Terminé",
                              style: TextStyle(
                                color: Colors.blue[900],
                              ),
                            ),
                            color: primaryColor,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        visible: !(!snapshot.hasData ||
                            (snapshot.hasData &&
                                snapshot.data != null &&
                                allcontactsAll.indexOf(snapshot.data) <
                                    allcontactsAll.length - 1)),
                      )
                    ],
                  ),
                ),
                /* */
              );
            },
          );
        },
      );
    });
    return null;
  }

  void showDialogBackupfileContent(FileSystemEntity f) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return StreamBuilder<List<Contact>>(
              stream: getBackupFileContentStream(f),
              builder: (context, snapshot) {
                return new AlertDialog(
                  backgroundColor: Colors.transparent,
                  //title: new Text("Material Dialog"),
                  content: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(20.0)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.26,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                  child: !snapshot.hasData
                                      ? CircularProgressIndicator()
                                      : Icon(
                                          Icons.check,
                                          size: 40,
                                          color: secondaryColor,
                                        )),
                            )
                          ],
                        ),
                        !snapshot.hasData
                            ? Text(
                                "Chargement en cours",
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              )
                            : Text(
                                "Chargement terminé ${snapshot.data.length} contact(s)",
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                        Visibility(
                          child: Container(
                              height: 65,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  bool loading = false;
                                  return loading
                                      ? Center(
                                          child: Container(
                                            height: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            "Restaurer",
                                            style: TextStyle(
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          color: primaryColor,
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            for (Contact c in snapshot.data) {
                                              dynamic result =
                                                  await ContactsService
                                                      .deleteContact(c);
                                              dynamic result1 =
                                                  await ContactsService
                                                      .addContact(c);
                                              print(result);
                                            }
                                            setState(() {
                                              loading = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  /* */
                );
              });
        },
      );
    });
  }
}
