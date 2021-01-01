import 'package:flutter/material.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/utils/theme.dart';
import 'package:numerotation/shared/AppTitleWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutActivity extends StatefulWidget {
  @override
  _AboutActivityState createState() => _AboutActivityState();
}

class _AboutActivityState extends State<AboutActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: AppTitleWidget(),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Communauté DART et FLUTTER de Côte d'Ivoire",
              style: Theme.of(context).textTheme.headline6.copyWith(),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                """
Fluttelephant est une communauté dart et flutter ivoirienne, créé  le 13 Août 2020 par Neiba Aristide et qui compte 55 membres.
Comme toutes communauté, le but est de partager nos connaissances, d'apprendre, de devenir meilleure et surtout adresser des problèmes communautaires en proposant des solutions informatiques.
Nous vous invitons donc à suivre notre communauté, à l'intégrer et surtout  n'hésitez pas à partager avec nous vos besoins.
Vous trouver ci-après le lien discorde de la communauté.
                  """,
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "res/icons/discord.png",
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Text("https://discord.gg/rpmKTAN"),
                  ],
                ),
                onPressed: () async {
                  const url = 'https://discord.gg/rpmKTAN';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    //throw 'Could not launch $url';
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
