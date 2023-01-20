import 'dart:convert';

import 'package:togetherearn/a1/models/instagram_account.model.dart';

import 'server.dart';
import '../../server/values.dart';
import 'package:http/http.dart' as http;

class IGTVServer {
  static Future igTVWatch(InstagramAccount account) async {}

  static Future igTVLike(
      {InstagramAccount account, String idToInteract}) async {
    var body = {
      "explore_source_token":
          "DxQyUlOyyQB6e3C00aCaooa3WfKq09bNi2sPzGZ6oQETVoSvyF08Yq8Ll9l3GtM5",
      //?
      "delivery_class": "organic",
      "media_id": idToInteract,
      "_csrftoken": account.csrftoken,
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "is_carousel_bumped_post": "false",
      "container_module": "igtv_preview_feed_contextual_chain",
      "feed_position": "0"
    };

    return igTVRequest(account, idToInteract, "like", body);
  }

  static Future igTVComment(
      {InstagramAccount account, String text, String idToInteract}) async {
    var body = {
      "user_breadcrumb": "",
      "delivery_class": "organic",
      "idempotence_token": adID,
      "carousel_index": "0",
      "_csrftoken": account.csrftoken,
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "comment_text": text,
      "is_carousel_bumped_post": "false",
      "container_module": "comments_v2_igtv_preview_feed_contextual_chain",
      "feed_position": "0"
    };

    return igTVRequest(account, idToInteract, "comment", body);
  }

  static Future igTVRequest(
      InstagramAccount account, String mediaID, String op, body) async {
    String signature = Server.generateSignature(data: jsonEncode(body));

    Map<String, String> header = {
      "X-IG-App-Locale": "tr_TR",
      "X-IG-Device-Locale": "tr_TR",
      "X-IG-Mapped-Locale": "tr_TR",
      "X-Pigeon-Session-Id": pigeonID,
      "X-Pigeon-Rawclienttime": "1609072393.620",
      "X-IG-Connection-Speed": 10000.toString() + "kbps",
      "X-IG-Bandwidth-Speed-KBPS": 9999999.toString(),
      "X-IG-Bandwidth-TotalBytes-B": 900000.toString(),
      "X-IG-Bandwidth-TotalTime-MS": 150.toString(),
      "X-IG-App-Startup-Country": "TR",
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": account.claim,
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": instaDeviceID,
      "X-IG-Android-ID": osID,
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Cookie":
          "csrfttoken=${account.csrftoken}; sessionId=${account.sessionID}; mid=${account.mid}; ig_direct_region_hint=ASH; rur=${account.rur}; ds_user_id=${account.dsUserID}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "DEBUG-IG-USER-ID": account.dsUserID,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "z-p42.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-Length": signature.length.toString() // add
    };

    String url = "media/$mediaID/$op/";

    var response = await http.post(Uri.parse(API_URL + url),
        headers: header, body: signature);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"] ?? "fail";
    }
  }
}
