import 'package:flutter/material.dart';
import 'package:togetherearn/a1/utils/constants.dart';

class CircleCheckBox extends StatefulWidget {
  final Function onSelected;
  final bool selected;
  final String label;
  const CircleCheckBox({Key key, this.onSelected, this.selected, this.label})
      : super(key: key);

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
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration:
                widget.selected ? selectedDecoration : unSelectedDecoration,
          ),
          SizedBox(
            width: 10, // add desired spacing between the checkbox and text
          ),
          Text(
            widget.label,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
/* 

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
} */
