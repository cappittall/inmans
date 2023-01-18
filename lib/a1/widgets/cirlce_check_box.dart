import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/constants.dart';

class CircleCheckBox extends StatefulWidget {
  final Function onSelected;
  final bool selected;

  const CircleCheckBox({Key key, this.onSelected, this.selected}) : super(key: key);

  @override
  _CircleCheckBoxState createState() => _CircleCheckBoxState();
}

class _CircleCheckBoxState extends State<CircleCheckBox> {
  BoxDecoration unSelectedDecoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: kMainColor, width: 0.7));

  BoxDecoration selectedDecoration =
      const BoxDecoration(shape: BoxShape.circle, color: kMainColor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelected,
      child: Container(
        height: 22,
        width: 22,
        decoration: widget.selected ? selectedDecoration : unSelectedDecoration,
      ),
    );
  }
}
