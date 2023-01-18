import 'package:flutter/material.dart';

class Spacer extends StatelessWidget {

  final int flex;

  const Spacer({Key key, this.flex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: SizedBox());
  }
}