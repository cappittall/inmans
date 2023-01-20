import 'package:flutter/material.dart';
import 'package:togetherearn/a1/utils/constants.dart';

class CustomLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.chevron_left,
        color: kMainColor,
        size: 35,
      ),
    );
  }
}
