import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoActivityIndicator(radius: 17);
    } else {
      return const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kSecondColor),
        ),
      );
    }
  }
}
