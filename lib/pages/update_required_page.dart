import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:open_store/open_store.dart';

class UpdateRequired extends StatelessWidget {
  const UpdateRequired({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getString("updateRequired"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  getString("updateAppToUse"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    onPressed: () async {
                      // go to play store or appstore
                      await OpenStore.instance.open(
                        appStoreId: '1571250132', // AppStore id of your app
                        androidAppBundleId:
                            "com.togetherearn.app", // Android app bundle package name
                      );
                    },
                    text: getString("update"))
              ],
            )),
      ),
    );
  }
}
