import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:togetherearn/a1/utils/multilang.dart';

import 'package:togetherearn/a1/instagramAccounts/add_instagram_account.dart';

import 'package:togetherearn/a1/utils/navigate.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:togetherearn/a1/widgets/custom_app_bar.dart';
import 'package:togetherearn/a1/widgets/custom_button.dart';

import 'package:togetherearn/a1/models/user.model.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/utils/constants.dart';

import '../models/local.model.dart';
import '../pages/register_page.dart';

class InstagramAccounts extends StatefulWidget {
  final User user;
  const InstagramAccounts({Key key, @required this.user}) : super(key: key);

  @override
  _InstagramAccountsState createState() => _InstagramAccountsState();
}

class _InstagramAccountsState extends State<InstagramAccounts> {
  bool loading = true;
  User user;

  @override
  void initState() {
    super.initState();

    loading = false;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    Map<String, dynamic> profil = user.profil;
    List instagrams = profil['instagram'];

    var instagramAccounts = instagrams.map((e) => InstagramAccount.fromData(e));

    return Background(
      child: !loading
          ? Container(
              child: Column(
                children: [
                  CustomAppBar(
                    title: getString("instaAccounts"),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: instagramAccounts
                          .where((element) => !element.ghost)
                          .map((account) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Material(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ' ${account.userName} - ${account.followersCount} ${getString("followers")} \n${account.error != "" ? "* ${getString(account.error)}" : ""}  ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                      onPressed: () async {
                                        // ignore: use_build_context_synchronously
                                        if (await confirm(context,
                                            title: Text(
                                              getString("attention"),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            content:
                                                Text(getString('areyousure')),
                                            textOK: Text(getString('yes')),
                                            textCancel:
                                                Text(getString('no')))) {
                                          instagrams.removeWhere(
                                              (e) => e['id'] == account.id);

                                          // headers
                                          Map<String, String> header = {
                                            "Content-Type":
                                                "application/json; charset=UTF-8",
                                            "Authorization":
                                                "Token ${profil['token']}"
                                          };

                                          //Databaseden de sil...
                                          http.Response response =
                                              await http.delete(
                                                  Uri.parse(
                                                      "$conUrl/api/instagram/${account.id}/"),
                                                  headers: header);
                                          print('response.statusCode...' +
                                              response.statusCode.toString());
                                          if (response.statusCode == 200) {
                                            // update new stuation on user instace.
                                            profil['instagram'] = instagrams;

                                            setState(() {
                                              user.profil = profil;
                                              Map<String, dynamic> userData =
                                                  userDataFromUser(user);
                                              writeUserDataToLocal(userData);
                                            });
                                          } else {
                                            //TODO: Handle if writing db deletion of insta account failed.
                                            // ignore: use_build_context_synchronously
                                            setState(() {
                                              loading = false;
                                            });
                                            showSnackBar(
                                                context,
                                                '${getString("somethingWentWrong")} - Status Code: ${response.statusCode} ',
                                                Colors.redAccent);
                                          }
                                        }
                                        setState(() { });
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  CustomButton(
                    onPressed: () async {
                      final Screen1Arguments args = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddInstagramAccount(),
                              settings: RouteSettings(
                                arguments: user,
                              )));

                      if (args != null) instagrams.add(args.myReturnMap);
                      profil['instagram'] = instagrams;

                      setState(() {
                        user.profil = profil;
                        //Write to local
                        Map<String, dynamic> userData = userDataFromUser(user);
                        writeUserDataToLocal(userData);
                      });
                    },
                    text: getString("addInstaAccount"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}
