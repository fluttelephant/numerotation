import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerotation/core/utils/theme.dart';

class RoundedCheckBox extends StatefulWidget {
  final Function onChanged;
  final bool value;

  const RoundedCheckBox(
      {Key key, @required this.onChanged, @required this.value})
      : super(key: key);

  @override
  _RoundedCheckBoxState createState() => _RoundedCheckBoxState();
}

class _RoundedCheckBoxState extends State<RoundedCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color:
                  widget.value ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.value ? primaryColor.withOpacity(0.0) : primaryColor,
                width: 2.0,
              ),
            ),
            child: Visibility(
              visible: widget.value,
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: primaryColor,

                ),
              ),
            ),
          ),
          onTap: () {
            widget.onChanged(widget.value);
          },
        ),
      ],
    );
  }
}
