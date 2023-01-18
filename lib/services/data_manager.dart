import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/services/operations/interaction_operator.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

import '../a1/pages/balance.dart';
import '../a1/instagramAccounts/globals.dart';

 
InstagramAccountDataManager instagramAccountDataManager =
    InstagramAccountDataManager();
 
class InstagramAccountDataManager with ChangeNotifier {

  Future addNewInstagramAccount(InstagramAccount account) async {
    Map<String, dynamic> data = {
      "user_id": "07666e7a-1957-11ec-9f88-1e00620a1240",
      "userName": account.userName ?? "",
      "password": account.password ?? "",
      "pwdPassword": account.pwdPassword ?? "",
      "claim": account.claim ?? "",
      "authToken": account.authToken ?? "",
      "csrftoken": account.csrftoken ?? "",
      "rur": account.rur ?? "",
      "dsUserID": account.dsUserID ?? "",
      "sessionID": account.sessionID ?? "",
      "mid": account.mid ?? "",
      "ghost": account.ghost ?? false,
      "gender": account.gender ?? "",
      "country": account.country ?? "",
      "adminArea": account.adminArea ?? "",
      "locality": account.locality ?? "",
      "subLocality": account.subLocality ?? "",
    };
    Uri uriforinsadd =
        Uri.parse("$conUrl/instagram/");

    final dataforinstadd = await http.post(
      uriforinsadd, 
      headers: {}, //TODO:
      body: data

    );

    if (dataforinstadd.statusCode == 200) {
      print(dataforinstadd.body);
    }
    await InteractionOperator.updateAccounts();

    notifyListeners();
  }




  Future<List<InstagramAccount>> getInstagramAccounts() async {
    Source source;

    int lastModified;
 
    await DataBaseManager.getAccountsLastModified().then((value) {
      try {
        lastModified = value;
      } catch (e) {
        lastModified = 0;
      }
    }); 

    if (localDataBox.containsKey("accountsLastModified")) {
      int localLastModified = localDataBox.get("accountsLastModified");
      if (localLastModified < lastModified) {
        source = Source.server;
        localDataBox.put("accountsLastModified", lastModified);
      } else {
        source = Source.cache;

        /// Get data from local
      }
    } else {
      source = Source.server;
      localDataBox.put("accountsLastModified", lastModified);

      /// get new data
    }
    print("source for instagram accounts $source");

    List<InstagramAccount> accounts = [];
    Uri uriforinsadd = Uri.parse(
        "http://127.0.0.1:8000/instagram/");
    final dataforaccounts = await http.get(uriforinsadd,
        headers: {"user_id": "07666e7a-1957-11ec-9f88-1e00620a1240"});
    if (dataforaccounts.statusCode == 200) {
      var unescape = HtmlUnescape();
      var converted = unescape.convert(dataforaccounts.body);
      var jsondata = jsonDecode(converted);

      if (jsondata["status"] == "sucsses")
        for (int i = 0; i < jsondata["accounts"].length; i++) {
          accounts.add(InstagramAccount.fromData(jsondata["accounts"][i]));
        }
    }
    print("uzunluk: ${accounts.length}");
    return accounts;
  }
}
