import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool loading;
  final bool onWhite;

  const CustomButton(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.loading = false,
      this.onWhite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: onWhite ? kSecondColor : kMainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: !loading
                  ? Text(
                      text,
                      style: TextStyle(
                          color: onWhite ? Colors.white : Colors.black),
                    )
                  : (!Platform.isIOS
                      ? const CupertinoActivityIndicator()
                      : const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF913248),
                            ),
                          ),
                        )),
            ),
          ),
        ),
        onPressed: onPressed);
  }
}
