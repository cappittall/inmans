import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/server/values.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user.model.dart';
import '../../pages/withdraw.dart';
import '../../utils/constants.dart';

class DataBaseManager {
  static DatabaseReference interactionDBRef;
  static DatabaseReference userDataDBRef;
  static DatabaseReference db;
  static DatabaseReference errorDB;

  static const String _interactionDBURL =
      "https://togetherearn-interactions.firebaseio.com/";
  static const String _userDataURL =
      "https://togetherearn-user-data.firebaseio.com/";

  static const String _errorDBURL =
      "https://insta-together-errors.firebaseio.com/";

  static DocumentReference _userDocument;
  static User currentUser;

  static get ServerValue => null;

  static get FieldValue => null;

  static Future setNewUSerData(data, uid) async {
    /* int timeStamp = DateTime.now().millisecondsSinceEpoch;

    await userDataDBRef.child("users").child(uid).set({
      "balance": 0,
      "penalty": 0,
      "accountsLastModified": timeStamp,
      "accountLastModified": timeStamp,
      "hts": timeStamp,
      "langCode": languageController.getLocale(),
      "emailVerified": false,
      "phoneVerified": false,
    });

    await usersRef.doc(uid).set(data); */
  }

  static String cleanWord(String word) {
    Map<String, String> replaceData = {
      "İ": "I",
      "Ü": "U",
      "Ö": "O",
      "Ğ": "G",
      "Ş": "S",
      "Ç": "C",
      "ğ": "g",
      "ü": "u",
      "ş": "s",
      "ı": "i",
      "ç": "c",
      ".": "",
      r"$": "",
      "[": "",
      "]": "",
      "#": "",
    };

    for (String data in replaceData.keys) {
      word = word.replaceAll(data, replaceData[data]);
    }
    return word;
  }

  static Future updatLocationData(List newTags, String gender,
      {String op = "add"}) async {
    print('>>Database_manager>L90 -> updatLocationData ');

    /* 
    try {
      print("Starting location update operation");
      var data = await db.child("locationTags").once();
      var tags = data.value ?? {};

      print("Got location data as $tags");

      for (String tag in newTags) {
        if (tag.trim() == "") {
          continue;
        }

        print("Operating for tag $tag");
        tag = cleanWord(tag);
        print("new tag: $tag");
        if (!tags.containsKey(tag)) {
          print("tag does not exists");

          if (op == "add") {
            tags[tag] = {};
            tags[tag][gender] = 1;
            tags[tag]["Both"] = 1;
          }
        } else {
          print("tag exist");
          print("tag $tag");
          print("gender: $gender");

          int count = tags[tag][gender] ?? 0;
          if (op == "add") {
            count++;
          }

          if (op == "remove") {
            count--;
          }

          tags[tag][gender] = count;
          if (gender != "Both") {
            int bothCount = tags[tag]["Both"] ?? 0;
            if (op == "add") {
              bothCount++;
            }

            if (op == "remove") {
              bothCount--;
            }

            tags[tag]["Both"] = bothCount;
          }
        }
      }

      await db.child("locationTags").set(tags);
    } catch (e) {
      DataBaseManager.errorDB
          .child(
              "locationErrors/${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}")
          .set({"error": e.toString(), "tags": newTags, "gender": gender});
    } */
  }

  static Future deactivateAccount(InstagramAccount account) async {
    /*usersRef FIXME:
        .doc(firebaseAuth.currentUser.uid)
        .collection("instagramAccounts")
        .doc(account.userName)
        .set({"active": false}, SetOptions(merge: true)); */
  }

  static Future<Map<String, dynamic>> getSupportedLocations() async {
    DataSnapshot data = await db.child("locationTags").once();
    Map<String, dynamic> result = jsonDecode(jsonEncode(data.value));
    return result;
  }

  static void initializeUser() {
    //FIXME: currentUser = firebaseAuth.currentUser;
    print('>>>> Database_Manager -> L169 initializeUser');
    /*  _userDocument = usersRef.doc(currentUser.uid);
    accountsRef = DataBaseManager.cloudFirestore
        .collection("users")
        .doc('firebaseAuth.currentUser.uid') //FIXME:
        .collection("instagramAccounts"); */
  }

  static Future updateTextData(String interactionKey, String key, Map typeData,
      textData, bool realtime) async {
    await DataBaseManager.interactionDBRef
        .child("textData")
        .child(interactionKey)
        .child(key)
        .update({
      "texts": textData,
    });
  }

  static Future setNewOperation(resultData) async {
    await _userDocument.collection("operationHistory").doc().set(resultData);
  }

  static Future updateLangCode(String langCode) async {
    userDataDBRef
        .child("users/{firebaseAuth.currentUser.uid}/langCode") //FIXME:
        .set(langCode);
  }

  static Future updateNotificationToken(String token) async {
    //await _userDocument.update({"notificationToken": token});
  }

  static Future updateIDData(data) async {
    /*  _userDocument.set({
      "idData": data,
    }, SetOptions(merge: true)); */
  }

  static Future<int> getAccountsLastModified() async {
    /*   Uri uriforinsremove = Uri.parse(
      "http://127.0.0.1:8000/api/getlastmodifed/?user_id=07666e7a-1957-11ec-9f88-1e00620a1240",
    );
    final dataforinstadd = await http.get(
      uriforinsremove,
    );
    if (dataforinstadd.statusCode == 200) {
      var unescape = HtmlUnescape();
      var converted = unescape.convert(dataforinstadd.body);
      var jsondata = jsonDecode(converted);
      return jsondata["time"];
    } else */
    return 0;
  }

  static Future setAccountsLastModified(int timeStamp) async {
    Uri uriforinsremove = Uri.parse(
      "http://127.0.0.1:8000/api/updatelastmodifedtime/",
    );
    await http.post(uriforinsremove, body: {
      "user_id": "07666e7a-1957-11ec-9f88-1e00620a1240",
      "time": timeStamp.toString()
    });
  }

  static Future setTC(tc) async {
    print('>>>>>>>Database_Manager->L308 >>>> SetTC');
    /* await usersRef
        .doc(currentUser.uid)
        .set({"TC": tc}, SetOptions(merge: true)); */
    /*  await userDataDBRef
        .child("users")
        .child(currentUser.uid)
        .child("accountLastModified")
        .set(DateTime.now().millisecondsSinceEpoch); */
  }

  static Future getBills() async {
    /* 
    Source source;

    String key = "historyLastModified";

    int lastModified;

    /* DataSnapshot snapshot = await DataBaseManager.userDataDBRef
        .child("users/{firebaseAuth.currentUser.uid}/hts")
        .once(); */

    lastModified = snapshot.value.toInt();

    print(lastModified);

    if (localDataBox.containsKey(key)) {
      int localLastModified = localDataBox.get(key);

      print(localLastModified);

      if (localLastModified < lastModified) {
        source = Source.server;
        localDataBox.put(key, lastModified);
      } else {
        source = Source.cache;

        /// Get data from local
      }
    } else {
      source = Source.server;
      localDataBox.put(key, lastModified);

      /// get
      ///
      // new data
    }

    List<BillModel> billModels = [];

    if (source == Source.cache && localDataBox.containsKey("billsData")) {
      var localData = localDataBox.get("billsData");
      billModels = localData.map<BillModel>((d) {
        return BillModel.fromLocalData(d);
      }).toList();
    } else {
      print("Getting data");
      /* await cloudFirestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("operationHistory")
          .where("type", whereIn: ["deposit", "withdraw"])
          .orderBy("timeStamp", descending: true)
          .get(GetOptions(source: source))
          .then((value) async {
            print("value $value");
            List localData = [];
            value.docs.forEach((element) async {
              // download pdf
              String pdfPath;

              String pdfLink;

              try {
                pdfLink = element.get("pdfLink");

                if (pdfLink != "-")
                  pdfPath =
                      await downloadPDF(url: pdfLink, fileName: element.id);
              } on Exception catch (e) {
                print("Error $e");
              } catch (e) {
                print("Error: $e");
              }

              var data = {
                "pdfLink": pdfPath,
                "operationID": element.id,
                "userID": currentUser.uid,
                "timeStamp": element.get("timeStamp"),
                "type": element.get("type"),
                "amount": element.get("operationData")["amount"],
              };

              billModels.add(BillModel.fromLocalData(data));
              localData.add(data);
            });

            localDataBox.put("billsData", localData);
          }); */
    }

    return billModels; */
  }

  static Future<String> downloadPDF({String url, String fileName}) async {
    var response = await http.get(Uri.parse(url));
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var folderPath = documentsDirectory.path + "/bills";
    var filePath = folderPath + "/$fileName.pdf".replaceAll(" ", "_");
    if (!Directory(folderPath).existsSync()) {
      await Directory(folderPath).create(recursive: true);
    }
    File image = File(filePath);
    await image.writeAsBytes(response.bodyBytes);

    return image.path;
  }

  static Future<String> get privacyPolicyURL async {
    launchUrl(Uri.parse('$conUrl/api/privacy-policy/'));
  }

  static void launchURL(url) async {
    bool cl = await canLaunch(url);

    if (cl) {
      await launch(url);
    } else {
      print("Failed to launch");
      DataBaseManager.errorDB
          .child(//FIXME:
              "urlErrors/{firebaseAuth.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}")
          .set({
        "urlError": "Failed to launch",
        "userAgent": userAgent.toString(),
      });
    }
  }

  static void initializeDatabases() {}
}

class SetOptions {}

class FirebaseDatabase {
  DatabaseReference reference() {}
}

class DocumentReference {
  collection(String s) {}

  update(Map<String, String> map) {}

  void set(Map<String, dynamic> map, setOptions) {}
}

class DatabaseReference {
  child(String s) {}
}

class GetOptions {}
