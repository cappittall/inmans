import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import '../server/values.dart';
import 'server/server.dart';

// LIVE BROADCAST ÇALIŞMIYOR SONRA YAPILACAK //
/////////////////
class LiveBroadCastServer {
  static Future<String> getLiveID(
      {InstagramAccount account, String accountID}) async {
    var url =
        "https://togetherearn.com/api/v1/requestInteractionID/?type=liveID&value=$accountID";

    var response = await http.get(Uri.parse(url), headers: {
      'Auth': 'KzcrTerX6SagIPgE1ZLaTy8t33QVMDbsWPithWYaYbX7rpQcIcI_HpFpuApMrEIb'
    });

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var broadcast = data["interactionID"];

      if (broadcast == "no-broadcast") {
        return "no-broadcast";
      }
      return broadcast;
    } else {
      return "fail";
    }
  }

  static Future watch({InstagramAccount account, String idToInteract}) async {
    Timer timer;

    int max = 30 * 60;

    var data = '_uuid=$guID&live_with_eligibility=1';
    String url =
        "https://i.instagram.com/api/v1/live/$idToInteract/heartbeat_and_get_viewer_count/";

    var response = await http.post(Uri.parse(url),
        body: data, headers: Server.createHeader(account, false));

    if (response.statusCode == 200) {
      timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        // send request

        var response = await http.post(Uri.parse(url),
            body: data, headers: Server.createHeader(account, false));

        if (response.statusCode != 200) {
          timer.cancel();
        }
        max -= 2;
        if (max <= 0) {
          timer.cancel();
        }
      });
      return "success";
    } else {
      print(response.body);
      return "fail";
    }
  }

  static Future comment(
      {InstagramAccount account, String text, String idToInteract}) async {
    var body = {
      "user_breadcrumb": "",
      "live_or_vod": "1",
      "idempotence_token": adID,
      "_uid": account.dsUserID,
      "_uuid": guID,
      "force_create": "false",
      "comment_text": text,
      "offset_to_video_start": "239"
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    var response = await http.post(
        Uri.parse("https://i.instagram.com/api/v1/live/$idToInteract/comment/"),
        headers: Server.createHeader(account, true),
        body: signature);
    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"] ?? "fail";
    }
  }

  static Future like({InstagramAccount account, String idToInteract}) async {
    print("live like trigger");
    var body = {
      "user_like_burst_count": "0",
      "_csrftoken": account.csrftoken,
      "_uid": account.dsUserID,
      "_uuid": guID,
      "user_like_count": "100",
      "offset_to_video_start": "179"
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    var response = await http.post(
        Uri.parse("https://i.instagram.com/api/v1/live/$idToInteract/like/"),
        headers: Server.createHeader(account, true),
        body: signature);

    print("Response from live like");
    print(response.body);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"] ?? "fail";
    }
  }
}
