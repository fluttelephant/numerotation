//CGUActivity
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:numerotation/core/GlobalTranslations.dart';

class CGUActivity extends StatefulWidget {
  @override
  _CGUActivityState createState() => _CGUActivityState();
}

class _CGUActivityState extends State<CGUActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String htmlData = "";

  bool loadingData = true;
  bool initializeLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<void> getCguDataHtml() async {
    loadingData = true;
    if (mounted) setState(() {});
    getFileData("res/cgu.html").then((value) {
      htmlData = value;
    }).whenComplete(() {
      loadingData = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (!initializeLoading) {
      initializeLoading = true;

      getCguDataHtml();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        title: Text(
          "${allTranslations.text("label_user_conditions")}",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: loadingData
            ? Container(
                height: size.height,
                width: size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Html(
                data: htmlData,
                //Optional parameters:
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                onImageTap: (src) {
                  print(src);
                },
                onImageError: (exception, stackTrace) {
                  print(exception);
                },
              ),
      ),
    );
  }
}
