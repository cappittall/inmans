import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmans/a1/pages/register_page.dart';
import 'package:inmans/a1/utils/navigate.dart';
import 'package:inmans/a1/models/user.model.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';
import 'package:inmans/a1/widgets/custom_button.dart';
import 'package:inmans/a1/widgets/custom_input_widget.dart';
import 'package:intl/intl.dart';
import 'package:inmans/a1/pages/home_page.dart';
import 'package:iban/iban.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

// Then somewhere in your code:

// ignore: use_function_type_syntax_for_parameters

class AccountPage extends StatefulWidget {
  final User user;
  const AccountPage({Key key, @required this.user}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  _AccountPageState();

  TextEditingController firstnameController;
  TextEditingController lastNameController;
  TextEditingController birth_dateController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController ibanController;
  TextEditingController bankController;
  TextEditingController coinController;
  TextEditingController coinAddressController;
  TextEditingController tcController;

  bool updateServer = true;

  Map profil;
  User user;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    String locale = Localizations.localeOf(context).languageCode;

    lastNameController = TextEditingController(text: user.last_name ?? '');
    firstnameController = TextEditingController(text: user.first_name ?? '');

    Map<String, dynamic> profil = user.profil as Map;
    print(
        'Profilllllllll:  ${profil['birth_date'].toString()},->  ${profil['birth_date'].runtimeType} \n$profil');

    birth_dateController = TextEditingController(
        text: profil['birth_date'].toString().substring(0, 10));
    emailController = TextEditingController(text: user.email ?? '');
    phoneController = TextEditingController(text: profil['phone'] ?? '');
    ibanController = TextEditingController(text: profil['iban'] ?? '');
    bankController = TextEditingController(text: profil['bank'] ?? '');
    tcController = TextEditingController(text: profil['tc'] ?? '');
    coinController = TextEditingController(text: profil['coin'] ?? '');
    coinAddressController =
        TextEditingController(text: profil['coin_adresi'] ?? '');

    return Scaffold(
      body: Background(
        child: user != null
            ? SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        title: getString("account"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          getString("basicInfo"),
                          style: const TextStyle(
                              fontSize: 19, color: Colors.white),
                        ),
                      ),
                      CustomTextInput(
                        hintText: getString("name"),
                        controller: firstnameController,
                      ),
                      CustomTextInput(
                        hintText: getString("lastName"),
                        controller: lastNameController,
                      ),
                      CupertinoButton(
                        onPressed: () async {
                          var resultDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(profil['birth_date']),
                            firstDate: DateTime(1930),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor:
                                      const Color.fromRGBO(197, 46, 8, 1),
                                  colorScheme: const ColorScheme.light(
                                      primary:
                                          Color.fromARGB(255, 196, 184, 15)),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child,
                              );
                            },
                          );

                          if (resultDate == null) {
                            return;
                          }
                          print(
                              'Date Result: $resultDate, ${resultDate.runtimeType}');

                          setState(() {
                            user.first_name = firstnameController.text;
                            user.last_name = lastNameController.text;
                            profil['birth_date'] =
                                resultDate.toString().substring(0, 10);
                          });
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kMainColor)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 12,
                              ),
                              (profil['birth_date'] != null)
                                  ? Text(
                                      dateFormatEnTr(
                                          profil['birth_date'].toString()),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      getString("birth_date"),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                            ],
                          )),
                        ),
                      ),
                      CustomTextInput(
                        hintText: getString("email"),
                        controller: emailController,
                        enabled: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      CustomTextInput(
                        hintText: getString("phone"),
                        controller: phoneController,
                        inputType: TextInputType.phone,
                      ),
                      /* CustomTextInput(
                        hintText: "TC No",
                        controller: tcController,
                        enabled: true,
                        inputType: TextInputType.number,
                      ), */
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          getString("paymentInfo"),
                          style: const TextStyle(
                              fontSize: 19, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "*" + getString("nameShouldBeSame"),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                      /* CustomTextInput(
                        hintText: getString("iban"),
                        controller: ibanController,
                        inputType: TextInputType.streetAddress,
                      ), */

                      /* IbanTextInput(
                          hintText: getString("iban"),
                          controller: ibanController,
                          isIban: true), */

                      /* CustomTextInput(
                        hintText: getString("bank"),
                        controller: bankController,
                        inputType: TextInputType.streetAddress,
                      ) */
                      CustomTextInput(
                        hintText: 'Crypto', //getString("Cripto"),
                        controller: coinController,
                        inputType: TextInputType.streetAddress,
                        enabled: false,
                      ),
                      CustomTextInput(
                        hintText: 'Crypto address', // getString("bank"),
                        controller: coinAddressController,
                        inputType: TextInputType.streetAddress,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                          onPressed: _onPressed,
                          child: Center(
                            child: Text(getString("eraseAccount"), 
                                  style: TextStyle(color: Colors.red, fontSize: 15), 
                                  textAlign: TextAlign.right),
                          ), ),
                      Builder(builder: (context) {
                        bool saveLoading = false;

                        return StatefulBuilder(
                            builder: (context, setButtonState) {
                          return CustomButton(
                              loading: saveLoading,
                              onPressed: () async {
                                if (saveLoading) {
                                  return;
                                }

                                /* if (!isValid(ibanController.text) &&
                                    ibanController.text.isNotEmpty) {
                                  showSnackBar(
                                      context,
                                      getString("invalidIBAN"),
                                      Colors.redAccent);
                                  saveLoading = false;
                                  return;
                                } */
                                setButtonState(() {
                                  saveLoading = true;
                                });
                                Map data = {
                                  'first_name': firstnameController.text,
                                  'last_name': lastNameController.text,
                                  'profil': {
                                    'birth_date': birth_dateController.text
                                        .substring(0, 10),
                                    'email': emailController.text,
                                    'phone': phoneController.text,
                                    'tc': tcController.text,
                                    'iban': ibanController.text,
                                    'bank': bankController.text,
                                    'coin': coinController.text,
                                    'coin_adresi': coinAddressController.text,
                                  }
                                };
                                print('HEEEEEEEEY $data');

                                User userx = await createUpdateUser(
                                    data, updateServer = true, user, context);

                                navigate(
                                    context: context,
                                    page: HomePage(),
                                    replace: true);

                                setButtonState(() {
                                  saveLoading = false;
                                });
                              },
                              text: getString("save"));
                        });
                      }),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(),
              ),
      ),
    );
  }

  String dateFormatEnTr(sd) {
    String dd = '2022-09-13';
    final DateFormat inputFormat = DateFormat('yyy-MM-dd');
    var inputDate = inputFormat.parse(sd); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);
    return outputDate;
  }

  void _onPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getString("areyousure")),
          content: Text(getString("eraseAccount")),
          actions: [
            TextButton(
              child: Text(getString("cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(getString("delete")),
              onPressed: () async {
                await deleteUser(user);
                navigate(context: context, page: LoginPage(), replace: true);
              },
            ),
          ],
        );
      },
    );
  }

  deleteUser(User user) {
    var url = Uri.parse('$conUrl/users/${user.id}');
    Response response = http.delete(url, headers: headers) as Response;
    if (response.statusCode == 200) {
      print('User deleted');

      showSnackBar(context, getString("userDeleted"), Colors.redAccent);
    }
  }
}
