import 'dart:convert';
import 'dart:io';

import 'package:contact_editor/contact_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/GlobalTranslations.dart';
import 'package:numerotation/core/utils/PhoneUtils.dart';
import 'package:path_provider/path_provider.dart';

class ExportScreenActivity extends StatefulWidget {
  final List<Contact> contacts;

  ExportScreenActivity({Key key, @required this.contacts}) : super(key: key);

  @override
  _ExportScreenActivityState createState() => _ExportScreenActivityState();
}

class _ExportScreenActivityState extends State<ExportScreenActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = false;

  String currentFileName = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    currentFileName = '$path/contact_${DateTime.now().toIso8601String()}.txt';
    return File(currentFileName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.contacts != null ? widget.contacts.length : "Aucun"} ${allTranslations.text("labelle_selected_contact")}",
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontSize: 26,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            color: Colors.blueGrey.withOpacity(0.12),
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.folder_circle_fill),
                                  Text("Local"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            color: Colors.blueGrey.withOpacity(0.12),
                            onPressed: null,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.cloud_fill),
                                  Text("Drive"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : ListView.builder(
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
                                  leading: CircleAvatar(
                                          child: Icon(
                                            CupertinoIcons.person_solid,
                                            size: 26,
                                            color: Colors.white,
                                          ),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.26),
                                        ),
                                  title: Text( contact.compositeName ??
                                      contact.nameData.firstName ??
                                      contact.nameData.middleName ??
                                      contact.nameData.surname ??
                                      contact.nickName ??
                                      ''),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .arrow_turn_down_right,
                                            size: 9,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "Phones : ${contact.phoneList.map((e) => e.mainData).join("; ")}")),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .arrow_turn_down_right,
                                            size: 9,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "Emails : ${contact.emailList.map((e) => e.mainData).join("; ")}")),
                                        ],
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
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          File file = await _localFile;

          print(currentFileName);
          print(widget.contacts.map((e) => e.toMap().toString()).join("\n"));
        },
        label: Text("${allTranslations.text("btn_save_labelle")}"),
        icon: Icon(CupertinoIcons.arrow_down_to_line_alt),
      ),
    );
  }
}
