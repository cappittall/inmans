import 'package:flutter/material.dart';

Future navigate(
    {@required BuildContext context,
    @required Widget page,
    bool replace = false}) async {
  Route route = MaterialPageRoute(
      builder: (context) => page, );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {

    return Navigator.push(context, route);
  }
}
