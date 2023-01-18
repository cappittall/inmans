import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/widgets/custom_leading.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({Key key, this.title, List<Widget> actions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          title,
          style: const TextStyle(color: kMainColor),
        ),
        elevation: 1,
        backgroundColor: Colors.transparent,
        leading: CustomLeading());
  }
}
