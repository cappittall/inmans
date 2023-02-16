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



    /**
        headers = {}
        headers['X-IG-App-Locale'] = 'tr_TR'
        headers['X-IG-Device-Locale'] = 'tr_TR'
        headers['X-IG-Mapped-Locale'] = 'tr_TR'
        headers['X-Pigeon-Session-Id'] = self.pigeonid
        headers['X-Pigeon-Rawclienttime'] = self.timestamp1(True)
        headers['X-IG-Bandwidth-Speed-KBPS'] = '-1.000'
        headers['X-IG-Bandwidth-TotalBytes-B'] = '0'
        headers['X-IG-Bandwidth-TotalTime-MS'] = '0'
        headers['X-IG-App-Startup-Country'] = 'TR'
        headers['X-Bloks-Version-Id'] = self.BloksVersionId
        headers['X-IG-WWW-Claim'] = self.claim
        headers['X-Bloks-Is-Layout-RTL'] = 'false'
        headers['X-Bloks-Is-Panorama-Enabled'] = 'true'
        headers['X-IG-Device-ID'] = self.deviceid
        headers['X-IG-Family-Device-ID'] = self.phoneid
        headers['X-IG-Android-ID'] = self.androidid
        headers['X-IG-Timezone-Offset'] = '10800'
        headers['X-IG-Connection-Type'] = 'MOBILE(LTE)'
        headers['X-IG-Capabilities'] = '3brTv10='
        headers['X-IG-App-ID'] = '567067343352427'
        headers[
            'User-Agent'] = self.USER_AGENT
        headers['Accept-Language'] = 'tr-TR, en-US'
        headers[
            'Authorization'] = self.authorization
        headers['X-MID'] = self.mid
        headers[
            'IG-U-SHBID'] = self.shbid
        headers[
            'IG-U-SHBTS'] = self.shbts
        headers['IG-U-DS-USER-ID'] = self.userid
        headers[
            'IG-U-RUR'] = self.rur
        headers[
            'IG-U-IG-DIRECT-REGION-HINT'] = self.region_hint
        headers['IG-INTENDED-USER-ID'] = self.userid
        headers['Accept-Encoding'] = 'gzip, deflate'
        headers['Host'] = 'b.i.instagram.com'
        headers['X-FB-HTTP-Engine'] = 'Liger'
        headers['X-FB-Client-IP'] = 'True'
        headers['X-FB-Server-Cluster'] = 'True'
        headers['Connection'] = 'keep-alive'
         */
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
      "offset_to_video_start": "77"
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
      "_uid": account.dsUserID,
      "_uuid": guID,
      "user_like_count": "99",
      "offset_to_video_start": "80"
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
