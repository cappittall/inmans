import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:inmans/a1/pages/forgot_password_page.dart';
import 'package:inmans/a1/pages/home_page.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/services/database/database_manager.dart';

import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';

import '../models/user.model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key, User user}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  Map userData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 3),
              const Text(
                appName,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(flex: 2),
              CustomTextInput(
                controller: emailController,
                hintText: getString("email"),
              ),
              CustomTextInput(
                controller: passwordController,
                hintText: getString("password"),
                hide: true,
              ),
              Builder(builder: (context) {
                bool loginLoading = false;

                return StatefulBuilder(builder: (context, setButtonState) {
                  return CustomButton(
                      text: getString("login"),
                      loading: loginLoading,
                      onPressed: () async {
                        if (loginLoading) {
                          return;
                        }

                        setButtonState(() {
                          loginLoading = true;
                        });

                        try {
                          User user = await signIn(emailController.text,
                              passwordController.text, context);

                          print('>>>>>>>>>>>>>Login page $user');
                          if (user != null) {
                            loginLoading = false;
                            // pop the page with signIn value
                            Navigator.pop(context, user);
                            
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnackBar(
                                context,
                                getString("somethingWentWrong"),
                                Colors.redAccent);
                            setButtonState(() {
                              loginLoading = false;
                            });
                          }
                        } catch (e) {
                          setButtonState(() {
                            print('Loginden hatalı $e');
                            loginLoading = false;
                          });
                        }
                      });
                });
              }),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: getString("noAccount?") + " ",
                      style: const TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    TextSpan(
                        text: getString("register"),
                        style: const TextStyle(color: kMainColor, fontSize: 20),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigate(context: context, page: RegisterPage());
                          })
                  ],
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: getString("forgotPassword?"),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigate(
                                context: context, page: ForgotPasswordPage());
                          })
                  ],
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: getString("privacyPolicy"),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            var url = await DataBaseManager.privacyPolicyURL;
                            DataBaseManager.launchURL(url);
                          })
                  ],
                ),
              ),
              const SizedBox(height: 25)
            ]),
          ),
        ),
      ),
    );
  }
}
