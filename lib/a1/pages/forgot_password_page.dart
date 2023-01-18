import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';

import 'package:inmans/a1/utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CustomAppBar(
                  title: getString("resetPassword"),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    getString("enterMailForReset"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextInput(
                  controller: mailController,
                  hintText: getString("email"),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () async {
                    if (mailController.text.trim() == "") {
                      return;
                    }
                    await sendPasswordResetMail(mailController.text);
                    // ignore: use_build_context_synchronously
                    showSnackBar(
                      context,
                      getString("passwordResetSent"),
                      Colors.black54,
                    );
                  },
                  text: getString("send"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendPasswordResetMail(String text) {
    http.post(Uri.parse('$conUrl/dj-rest-auth/password/reset/'),
    body:jsonEncode({'email': text})
    );

    ///dj-rest-auth/password/reset/
  }

  
}
