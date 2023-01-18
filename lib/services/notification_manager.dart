import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';


class NotificationManager {
  FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    /// handle in app notification
    print("Got local notification: ");
    print("details: $id - $title - $body - $payload");
  }

  Future initializeNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await notification.initialize(initializationSettings);
  }

  Future showNotification(String title, String body) async {
    int id = 0;

    if (localDataBox.containsKey("notificationID")) {
      id = localDataBox.get("notificationID") + 1;
    } else {
      localDataBox.put("notificationID", id);
    }

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            "inmans-notifications", "Notifications for inmans");
    IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await notification.show(id, title, body, notificationDetails);
  }

  Future updateNotificationToken(String token) async {
   // await DataBaseManager.updateNotificationToken(token);
  }

  void createNotificationListener() async {
    String token = 'fcm.getToken()';

    await notificationManager.updateNotificationToken(token);

    if (Platform.isIOS) {
    /*   fcm.requestPermission(
        sound: true,
        alert: false,
      ); */
    }

    print("creating listeners");

    /* FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("message opened app");

      Map<String, dynamic> data = message.data;

      if (data["notificationType"] == "newPenalty") {
        //navigate(context: context, page: PenaltiesPage());
      }
    }); */

    /* FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> data = message.data;

      if (data["notificationType"] == "newPenalty") {
        print("Got penalty");
        showNotification(getString("newPenalty"),
            getString(data["type"]).replaceAll("{username}", data["username"]));

        return;
      } else if (data["notificationType"] == "ghostAccount") {
        List<String> accounts = data["accountData"].split(",");

        for (String account in accounts) {
          String username = account.split(":")[0];
          String password = account.split(":")[1];

          var loginResult = await LoginServer.login(
              username: username, password: password, ghost: true);

          if (loginResult != null) {
            InstagramAccount newAccount =
                InstagramAccount.fromData(loginResult);
            int genderResult = await Server.getGender(newAccount);

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

            List locationTags = localDataBox.get("locationTags");

            if (locationTags != null || locationTags.isNotEmpty) {
              //DataBaseManager.updatLocationData(locationTags, gender);
            }

            newAccount.gender = gender;

            if (localDataBox.containsKey("locationTags")) {
              newAccount.setTags(localDataBox.get("locationTags"));
            }

            await instagramAccountDataManager
                .addNewInstagramAccount(newAccount);

            print("Instagram account added with username $username");
          } else {
            print("login failed for username: $username");
          }
        }
        InteractionOperator.updateAccounts();
      }
    }); */
  }
}
