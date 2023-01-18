import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/a1/pages/pages.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_button.dart';

import '../a1/widgets/ggy_loading_indicator.dart';

class CheckVerification extends StatefulWidget {
  const CheckVerification({Key key}) : super(key: key);

  @override
  _CheckVerificationState createState() => _CheckVerificationState();
}

class _CheckVerificationState extends State<CheckVerification> {
  bool emailVerified;
  bool phoneVerified;

  TextEditingController phoneController = TextEditingController();
  TextEditingController code = TextEditingController();

  String countryCode = "90";
  String selectedCountry = "TR";

  String phone;

  bool waitingCode = false;

/*   StreamSubscription<User> listener;

  Future checkVerifications() async {
    listener = firebaseAuth.userChanges().skip(1).listen((event) async {
      if (event != null) {
        var data = await DataBaseManager.userDataDBRef
            .child("users")
            .child("${firebaseAuth.currentUser.uid}/phoneVerified")
            .once();
        setState(() {
          emailVerified = firebaseAuth.currentUser.emailVerified;

          var pv = data.value;

          if (pv == null) {
            phoneVerified = false;
          } else {
            phoneVerified = pv;
          }
        });
      } else {}
    });
  } 

  @override
  void initState() {
    checkVerifications();
    super.initState();
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    /* if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.reload();
    } */
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     firebaseAuth.currentUser.unlink("phone");
      //   },
      // ),
      body: Background(
        child: emailVerified != null
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getString("verificationRequired"),
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
                      getString("verificationDescription"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text(getString("email"),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 25)),
                          const Spacer(),
                          if (emailVerified)
                            const Icon(Icons.check, color: Colors.green),
                          if (!emailVerified)
                            const Icon(Icons.close, color: Colors.red),
                          if (!emailVerified)
                            CupertinoButton(
                              onPressed: () async {
                                /* await firebaseAuth.currentUser
                                    .sendEmailVerification(); */
                                showSnackBar(
                                    context,
                                    getString("verificationEmailSent"),
                                    Colors.green);
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(getString("verify"),
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 20)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text(getString("phone"),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 25)),
                          const Spacer(),
                          if (phoneVerified)
                            const Icon(Icons.check, color: Colors.green),
                          if (!phoneVerified)
                            const Icon(Icons.close, color: Colors.red),
                          if (!phoneVerified)
                            CupertinoButton(
                              onPressed: () async {
                                //showPhoneDialog();
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(getString("verify"),
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 20)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (waitingCode)
                      const Text("Kod gönderiliyor...",
                          style: TextStyle(color: Colors.white)),
                    if (waitingCode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 50, width: 50, child: LoadingIndicator())
                        ],
                      ),
                    CustomButton(
                        onPressed: () async {
                          if (emailVerified) {
                            DataBaseManager.userDataDBRef
                                .child("users")
                                .child('firebaseAuth.currentUser.uid')
                                .child("emailVerified")
                                .set(true);
                          }

                          if (emailVerified && phoneVerified) {
                            navigate(
                                context: context,
                                page: const HomePage(),
                                replace: true);
                            localDataBox.put("verified", true);
                            DataBaseManager.initializeUser();
                            notificationManager.createNotificationListener();
                          } else {
                            showSnackBar(context,
                                getString("verificationRequired"), Colors.red,
                                ms: 1200);
                          }
                        },
                        text: emailVerified && phoneVerified
                            ? getString("continue")
                            : getString("check"))
                  ],
                ))
            : Container(),
      ),
    );
  }
}
