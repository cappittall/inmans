import 'package:flutter/material.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/multilang.dart';

class VersionFailed extends StatelessWidget {
  const VersionFailed({Key key}) : super(key: key);
  
  final String link ="https://play.google.com/store/apps/details?id=com.togetherearn.app";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getString("updateAppToUse"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle URL link tap event
                    launchUrl(Uri.parse('$link'));
                  },
                  child: const Text(
                    "Playstore Link",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),


    );}}