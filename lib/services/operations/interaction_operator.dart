import 'dart:async';
import 'dart:typed_data';
import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/services/data_manager.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:http/http.dart' as http;
import 'package:inmans/a1/instagramAccounts/server/interaction_server.dart';
import 'package:inmans/a1/server/values.dart';
import 'package:inmans/a1/utils/multilang.dart';
import '../../a1/instagramAccounts/server/interaction_types.dart';


/* const prices = {
  "0-100": {
    "comment": 0.002,
    "follow": 0.001,
    "liveWatch": 0.001,
    "like": 0.001,
    "postShare": 1,
    "storyShare": 1,
    "videoShare": 1,
    "dm": 0.001,
    "postSave": 0.001,
  },
  "100-500": {
    "comment": 0.0025,
    "follow": 0.00125,
    "liveWatch": 0.00125,
    "like": 0.00125,
    "postShare": 1.25,
    "storyShare": 1.25,
    "videoShare": 1.25,
    "dm": 0.00125,
    "postSave": 0.00125,
  },
  "500-1000": {
    "comment": 0.003,
    "follow": 0.0015,
    "liveWatch": 0.0015,
    "like": 0.0015,
    "postShare": 1.5,
    "storyShare": 1.5,
    "videoShare": 1.5,
    "dm": 0.0015,
    "postSave": 0.0015,
  },
  "1000-3000": {
    "comment": 0.0035,
    "follow": 0.00175,
    "liveWatch": 0.00175,
    "like": 0.00175,
    "postShare": 1.75,
    "storyShare": 1.75,
    "videoShare": 1.75,
    "dm": 0.0000175,
    "postSave": 0.00175,
  },
  "3000-5000": {
    "comment": 0.004,
    "follow": 0.002,
    "liveWatch": 0.002,
    "like": 0.002,
    "postShare": 2.5,
    "storyShare": 2.5,
    "videoShare": 2.5,
    "dm": 0.002,
    "postSave": 0.002,
  },
  "5000+": {
    "comment": 0.0045,
    "follow": 0.00225,
    "liveWatch": 0.00225,
    "like": 0.00225,
    "postShares": 3,
    "storyShares": 3,
    "videoShares": 3,
    "dm": 0.00225,
    "postSaves": 0.00225,
  },
};  */

class InteractionOperator {
  static List<InstagramAccount> _currentInstagramAccounts = [];

  static List<InstagramAccount> get instagramAccounts =>
      _currentInstagramAccounts;

  static bool started = false;

  static Future updateAccounts() async {
  /*   _currentInstagramAccounts =
        await instagramAccountDataManager.getInstagramAccounts(); */
  }

  static List<List<StreamSubscription>> listeners = [];

  static void cancelListeners() async {
    print("Cancel listeners");
    started = false;
    for (List<StreamSubscription> listenerList in listeners) {
      for (StreamSubscription l in listenerList) {
        print("Listener $l");
        if (l != null) {
          print("Cancelling listener");
          await l.cancel();
        }
      }
    }

    listeners = [];
  }

  static void startInteractions(bool isbackground) async {
    _currentInstagramAccounts =
        await instagramAccountDataManager.getInstagramAccounts();

    started = true;

    cancelListeners();

    for (var interactionKey in interactionTypesData.keys) {
      print(interactionKey);
      List<StreamSubscription> interactionListeners = createListener(
          interactionKey: interactionKey,
          typeData: interactionTypesData[interactionKey],
          isbackground: isbackground);

      listeners.add(interactionListeners);
    }
  }

  static List<String> shareOps = [
    "postShares",
    "videoShares",
    "storyShares",
  ];

  static Future<bool> checkLike(
      InstagramAccount account, String mediaID) async {
    return await InteractionServer.hasLiked(account: account, mediaID: mediaID);
  }

  static Future<bool> checkFollow(
      InstagramAccount account, String accountID) async {
    return await InteractionServer.following(
        account: account, accountID: accountID);
  }

  static List<StreamSubscription> createListener(
      {String interactionKey, Map typeData, bool isbackground}) {
    print("Creating listener for $interactionKey");
    int opTimeStamp;

    String localTimeStampKey = typeData["localTimeStampKey"];

    if (localDataBox.containsKey(localTimeStampKey)) {
      opTimeStamp = localDataBox.get(localTimeStampKey);
      int newTimeStamp = DateTime.now().millisecondsSinceEpoch;
      localDataBox.put(localTimeStampKey, newTimeStamp);
    } else {
      opTimeStamp = 0;
      int newTimeStamp = DateTime.now().millisecondsSinceEpoch;
      localDataBox.put(localTimeStampKey, newTimeStamp);
    }

    void listenFunc(data, parentKey, bool realtime) async {
      int operationCount;
      if (localDataBox.containsKey(typeData["operationCountKey"])) {
        if (localDataBox.containsKey(typeData["operationCountKey"] + "time")) {
          int operationTimeStamp =
              localDataBox.get(typeData["operationCountKey"] + "time");

          if (DateTime.now()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(operationTimeStamp))
                  .inHours
                  .abs() >
              24) {
            operationTimeStamp = DateTime.now().millisecondsSinceEpoch;
            localDataBox.put(
                typeData["operationCountKey"] + "time", operationTimeStamp);
            localDataBox.put(typeData["operationCountKey"], 0);
          }
        } else {
          localDataBox.put(typeData["operationCountKey"] + "time",
              DateTime.now().millisecondsSinceEpoch);
          localDataBox.put(typeData["operationCountKey"], 0);
        }

        operationCount = localDataBox.get(typeData["operationCountKey"]);
      } else {
        operationCount = 0;
        localDataBox.put(typeData["operationCountKey"], 0);
      }

      if (operationCount > typeData["limit"]) {
        print("limit reached for $interactionKey");
        return;
      }

      String idToInteract = data[typeData["idCode"]].toString();
      String tempID = idToInteract;
      bool paid = data["paid"];

      bool isLive = interactionKey.contains("live");
      bool isShareOP = shareOps.contains(interactionKey);

      Uint8List bytes;
      String text;

      if (isShareOP) {
        http.Response response = await http.get(Uri.parse(idToInteract));
        bytes = response.bodyBytes;
      }

      print("Creating ops for accounts");

      bool successOp;

      String selectedAccount = data["accountUserName"];

      print(selectedAccount);

      int indexOfAccount = _currentInstagramAccounts
          .indexWhere((acc) => acc.userName == selectedAccount);

      if (indexOfAccount == -1) {
        print("Account not found in users accounts");
        return;
      }

      InstagramAccount account = _currentInstagramAccounts[indexOfAccount];

      if (account == null) {
        return;
      }

      try {
        /// Check previous interaction
        if (interactionKey.toLowerCase().contains("like")) {
          bool liked = await checkLike(account, idToInteract);
          if (liked) {
            print("[Already liked]");
            return;
          }
        }

        if (interactionKey == "usersToFollow") {
          bool following = await checkFollow(account, idToInteract);
          if (following) {
            print("[Already following]");
            return;
          }
        }

        print("getting result");

        String result;

        if (typeData["functionParam"] == 2) {
          print("function param 2");

          /// Like, Follow operations
          result = await typeData["function"](
              idToInteract: idToInteract, account: account);

          print("got result");
        } else {
          /// Comment, Share, dm operations
          if (isShareOP) {
            text = data[typeData["textData"]];
          }

          if (interactionKey == "multiUserDMs") {
            idToInteract = data["accountID"].toString();
            text = data["text"];

            result = await typeData["function"](
                idToInteract: isShareOP ? bytes : idToInteract,
                account: account,
                text: text);
          } else if (interactionKey == "singleUserDMs") {
            text = data["message"].toString();
            idToInteract = data["text"];

            result = await typeData["function"](
                idToInteract: isShareOP ? bytes : idToInteract,
                account: account,
                text: text);
          } else {
            text = data["text"];

            result = await typeData["function"](
                idToInteract: isShareOP ? bytes : idToInteract,
                account: account,
                text: text);
          }
        }

        print("result: $result");

        if (result == "success") {
          successOp = true;
          int timeStamp = DateTime.now().millisecondsSinceEpoch;

          var resultData = typeData["resultData"];

          resultData["paid"] = paid;
          resultData["timeStamp"] = timeStamp;
          resultData["ghost"] = account.ghost;
          resultData["operationData"][typeData["idCode"]] = idToInteract;
          resultData["username"] = account.userName;
          resultData["operationData"]["interactionDB"] = interactionKey;

          if (typeData["functionParam"] != 2) {
            resultData["operationData"]["text"] = text;
          }

          if (isLive) {
            resultData["operationData"][typeData["idCode"]] = tempID;
            resultData["operationData"]["liveID"] = idToInteract;
          }

          Map<String, num> priceData;

          int followerCount =
              await InteractionServer.getFollowerCount(account.userName);

        /*   if (followerCount <= 100) {
            priceData = prices["0-100"];
          } else if (followerCount <= 500) {
            priceData = prices["100-500"];
          } else if (followerCount <= 1000) {
            priceData = prices["500-1000"];
          } else if (followerCount <= 3000) {
            priceData = prices["1000-3000"];
          } else if (followerCount <= 5000) {
            priceData = prices["3000-5000"];
          } else {
            priceData = prices["5000+"];
          }
 */
          String type;

          String opType = typeData["resultData"]["type"];

          switch (opType) {
            case "postLikes":
            case "commentLikes":
            case "reelsLikes":
            case "igtvLikes":
            case "liveLikes":
              type = "like";
              break;
            case "postComments":
            case "igtvComments":
            case "reelsComments":
            case "liveComments":
              type = "comments";
              break;
            case "singleUserDMs":
            case "multiUserDMs":
              type = "dm";
              break;
            case "spams":
            case "suicideSpams":
              type = "spam";
              break;
            default:
              type = opType;
          }

          var prize = priceData[type];

          resultData["paidAmount"] = prize ?? 0;

          if (type != "spam") {
            await DataBaseManager.setNewOperation(resultData);
          }

          /* await DataBaseManager.interactionDBRef
              .child(
                  "usersInteractions/${DataBaseManager.currentUser.uid}/$interactionKey/$parentKey/active")
              .set(false); */
          /* await DataBaseManager.interactionDBRef
              .child("mainInteractions/${data["mainID"]}")
              .update({"interaction": ServerValue.increment(1)}); */

          operationCount++;

          localDataBox.put(localTimeStampKey, timeStamp);
        } else if (result == "login_required") {
          successOp = false;
          if (!account.ghost) {
            notificationManager.showNotification(
                getString("actionRequired"),
                getString("actionRequiredAccount")
                    .replaceAll("{username}", account.userName));
          }
        } else if (result == "challenge_required") {
          if (!account.ghost) {
            notificationManager.showNotification(
                getString("challengeRequired")
                    .replaceAll("{username}", account.userName),
                getString("challengeRequiredDetail")
                    .replaceAll("{username}", account.userName));
          }
        } else {
          successOp = false;
          DataBaseManager.errorDB.child("resultTypes/$result").set({
            "interactionDB": interactionKey,
            "username": account.userName,
          });
        }
      } on Exception catch (e) {
        successOp = false;
        print(e);
        print("something went wrong");

        DataBaseManager.errorDB
            .child( //FIXME:
                "interactionErrors/'{firebaseAuth.currentUser.uid}'/${DateTime.now().millisecondsSinceEpoch}")
            .set({
          "error": e.toString(),
          "userAgent": userAgent,
        });
      } catch (e) {
        successOp = false;
        print(e);

        print("something went wrong");

        DataBaseManager.errorDB
            .child(   //FIXME:
                "interactionErrors/'{firebaseAuth.currentUser.uid}'/${DateTime.now().millisecondsSinceEpoch}")
            .set({
          "error": e.toString(),
          "userAgent": userAgent,
        });
      }

      if (successOp != null) {
        if (successOp) {
          localDataBox.put(typeData["operationCountKey"], operationCount);
        }
      }
    }

   /*  var db = DataBaseManager.interactionDBRef
        .child("usersInteractions")
        .child(DataBaseManager.currentUser.uid)
        .child(interactionKey)
        .orderByChild("active")
        .equalTo(true)
        .reference()
        .orderByChild("timeStamp")
        .startAt(opTimeStamp)
        .reference(); */
    print(">>>>> Database_Manager L458. ");
    /* db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data != null)
        data.forEach((key, value) {
          print("bana gereken key : $key");
          listenFunc(data, key, true);
        });
    }); */
    StreamSubscription<Event> listener1;
   /*  if (!isbackground)
      listener1 = DataBaseManager.interactionDBRef
          .child("usersInteractions")
          .child(DataBaseManager.currentUser.uid)
          .child(interactionKey)
          .orderByChild("active")
          .equalTo(true)
          .reference()
          .orderByChild("timeStamp")
          .startAt(opTimeStamp)
          .onChildAdded
          .listen((Event event) async {
        //Map<dynamic, dynamic> data = event.snapshot.value;

        // ignore: avoid_print
        //print(data);

        //String parentKey = event.snapshot.key;
        //listenFunc(data, parentKey, true);
      }); */

    return [listener1];
  }
}

class Event {
}
