// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/pages/home_page.dart';
import 'package:inmans/a1/localization/language_controller.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';
import 'package:inmans/a1/widgets/custom_leading.dart';
import 'package:inmans/a1/models/user.model.dart';

import '../services/database/database_manager.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool termsAccepted = false;
  TextEditingController emailController =
      TextEditingController(text: 'hak001@gmail.com');
  TextEditingController phoneController =
      TextEditingController(text: '555 55 55 555');
  TextEditingController passwordController =
      TextEditingController(text: 'aspros99100');
  TextEditingController passwordConfirmController =
      TextEditingController(text: 'hakunamatata22');
  TextEditingController firstnameController =
      TextEditingController(text: 'hak00');
  TextEditingController lastNameController =
      TextEditingController(text: 'cetin');

  User user;
  bool loading = false;
  bool updateServer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: CustomLeading()),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(getString("starredFields"),
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              CustomTextInput(
                hintText: "*" + getString("name"),
                controller: firstnameController,
              ),
              CustomTextInput(
                hintText: "*" + getString("lastName"),
                controller: lastNameController,
              ),
              const SizedBox(height: 30),
              CustomTextInput(
                hintText: "*" + getString("email"),
                controller: emailController,
              ),
              CustomTextInput(
                hintText: "*" + getString("phone"),
                inputType: TextInputType.number,
                controller: phoneController,
              ),
              const SizedBox(height: 30),
              CustomTextInput(
                hintText: "*" + getString("password"),
                controller: passwordController,
                hide: true,
              ),
              CustomTextInput(
                hintText: "*" + getString("passwordConfirm"),
                controller: passwordConfirmController,
                hide: true,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: termsAccepted,
                    onChanged: (bool term) {
                      setState(() {
                        termsAccepted = term;
                      });
                    },
                  ),
                  if (languageController.getLocale() == "tr")
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: getString("termsOfUse") + " ",
                              style: const TextStyle(
                                  color: kMainColor, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url =
                                      await DataBaseManager.privacyPolicyURL;
                                  DataBaseManager.launchURL(url);
                                }),
                          TextSpan(
                            text: getString("IAccept"),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  if (languageController.getLocale() != "tr")
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: getString("IAccept") + " ",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                          TextSpan(
                              text: getString("termsOfUse"),
                              style: const TextStyle(
                                  color: kMainColor, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url =
                                      await DataBaseManager.privacyPolicyURL;
                                  DataBaseManager.launchURL(url);
                                }),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: getString("register"),
                  onPressed: () async {
                    loading = true;
                    if (termsAccepted) {
                      if (passwordConfirmController.text.trim() == "" ||
                          passwordController.text.trim() == "" ||
                          firstnameController.text.trim() == "" ||
                          lastNameController.text.trim() == "" ||
                          phoneController.text.trim() == "" ||
                          emailController.text.trim() == "") {
                        showSnackBar(context, getString("fieldsEmpty"),
                            Colors.redAccent);
                        loading = false;

                        return;
                      }

                      if (passwordController.text ==
                          passwordConfirmController.text) {
                        Map<String, dynamic> data = {
                          "first_name": firstnameController.text,
                          "last_name": lastNameController.text,
                          "email": emailController.text,
                          "password": passwordController.text,
                          "username": emailController.text,
                          "profil": {
                            "phone": phoneController.text,
                          }
                        };

                        User user = await createUpdateUser(
                            data, updateServer = false, null, context);

                        if (user != null) {
                          loading = false;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                  settings: RouteSettings(
                                    arguments: user,
                                  )));
                        } else {
                          showSnackBar(
                              context, getString("nosucces"), Colors.redAccent);
                        }
                      } else {
                        showSnackBar(context, getString("passwordsNotEqual"),
                            Colors.redAccent);

                        loading = false;

                        return;
                      }
                    } else {
                      showSnackBar(context, getString("termsShouldBeAccepted"),
                          Colors.redAccent);

                      loading = false;

                      return;
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String msg, Color color,
    {int ms = 1500, bool isLong = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration:
        isLong ? Duration(milliseconds: ms) : Duration(milliseconds: 5000),
    content: Text(
      msg,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    action: isLong
        ? SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          )
        : null,
  ));
}
