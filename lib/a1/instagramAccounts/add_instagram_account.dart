// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/a1/models/user.model.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/a1/server/login_server.dart';
import 'package:inmans/a1/instagramAccounts/server/server.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';
import 'package:inmans/a1/utils/constants.dart';

class AddInstagramAccount extends StatefulWidget {
  final User user;

  const AddInstagramAccount({Key key, @required this.user}) : super(key: key);
  @override
  _AddInstagramAccountState createState() => _AddInstagramAccountState();
}

class _AddInstagramAccountState extends State<AddInstagramAccount> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User user;

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;

    return Scaffold(
        body: Background(
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CustomAppBar(
            title: getString("addInstaAccount"),
          ),
          const Spacer(),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kMainColor, width: 2)),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        border: Border.all(color: kMainColor, width: 2),
                        shape: BoxShape.circle),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kMainColor),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomTextInput(
              hintText: getString("username"), controller: userNameController),
          CustomTextInput(
            hintText: getString("password"),
            controller: passwordController,
            hide: true,
          ),
          Builder(builder: (context) {
            bool buttonLoading = false;

            return StatefulBuilder(builder: (context, setButtonState) {
              return CustomButton(
                onPressed: () async {
                  if (buttonLoading) {
                    return;
                  }

                  setButtonState(() {
                    buttonLoading = true;
                  });

                  await Server.getDeviceInfo(context);
                  await Server.generateIDs();

                  var loginResult = await LoginServer.login(
                      username: userNameController.text,
                      password: passwordController.text);

                  print('Login Result: $loginResult');
                  if (loginResult == null) {
                    setButtonState(() {
                      buttonLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                    showSnackBar(context, getString("instaAccountAdFail"),
                        Colors.redAccent);
                    return;
                  } else {
                    Map<String, dynamic> profil = user.profil;
                    loginResult['id'] = profil['id'];

                    InstagramAccount account =
                        InstagramAccount.fromData(loginResult);

                    int genderResult = await Server.getGender(account);

                    // Test etme
                    String gender;

                    if (genderResult != null) {
                      if (genderResult == 2) {
                        gender = "Kadın";
                      } else if (genderResult == 1) {
                        gender = "Erkek";
                      } else {
                        gender = "Both";
                      }
                    } else {
                      gender = "Both";
                    }
                    print('User , $user  ');

                    List tags = [
                      profil['place']['subLocality'],
                      profil['place']['subAdministrativeArea'],
                      profil['place']['administrativeArea'],
                      profil['place']['country']
                    ];

                    account.gender = gender;
                    account.setTags(tags);

                    Map<String, String> header = {
                      "Content-Type": "application/json; charset=UTF-8",
                      "Authorization": "Token ${profil['token']}"
                    };

                    Map<String, dynamic> body =
                        await instaDataFromAccount(account);

                    print('HEADER: $header');
                    print('BODY: ${jsonEncode(body)}');
                    http.Response response = await http.post(
                        Uri.parse("$conUrl/api/instagram/"),
                        body: jsonEncode(body),
                        headers: header);

                    print(utf8.decode(response.bodyBytes));

                    var newBody =
                        jsonDecode(utf8.decode(response.bodyBytes)) as Map;

                    print('Statuse code: ${response.statusCode}');

                    if (response.statusCode == 201) {
                      setButtonState(() {
                        buttonLoading = false;
                      });

                      showSnackBar(context, getString("instaAccountAdded"),
                          Colors.black45);
                      await Future.delayed(
                          const Duration(milliseconds: 600), () {});
                      Navigator.pop(context, Screen1Arguments(newBody));
                    } else {
                      //Handle if request to database not success
                      showSnackBar(
                          context,
                          '${getString("somethingWentWrong")} - Status Code: ${response.statusCode} ',
                          Colors.redAccent);
                    }
                  }
                },
                text: getString("add"),
                loading: buttonLoading,
              );
            });
          }),
          Center(
              child: Text(
            "*${getString("justAddOpenAccounts")}",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          )),
          const Spacer(
            flex: 2,
          ),
        ]),
      ),
    ));
  }
}
