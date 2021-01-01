
import 'package:flutter/material.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Passe à 10",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
