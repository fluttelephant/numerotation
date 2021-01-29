import 'package:flutter/material.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final double height;

  CustomElevation({@required this.child, @required this.height})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(this.height / 2)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: height / 5,
            offset: Offset(0, height / 5),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
