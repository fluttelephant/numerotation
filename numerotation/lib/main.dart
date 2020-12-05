import 'package:flutter/material.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/GlobalTranslations.dart';

import 'NumerotationApp.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await start();
  await allTranslations.init();
  runApp(NumerotationApp());
}

Future start() async {
  await App.init();
}
