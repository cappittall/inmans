import 'dart:convert';

import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:http/http.dart' as http;
import 'server.dart';
import '../../server/values.dart';

class ReelsServer {
  static Future reelsWatch(
      {InstagramAccount account, String idToInteract}) async {}

  static Future reelsLike(
      {InstagramAccount account, String idToInteract}) async {
    var body = {
      "delivery_class": "organic",
      "media_id": idToInteract,
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "is_carousel_bumped_post": "false",
      "container_module": "clips_viewer_explore_popular_minor_unit",
      "feed_position": "0"
    };

    return reelsRequest(account, idToInteract, "like", body);
  }

  static Future reelsComment(
      {InstagramAccount account, String text, String idToInteract}) async {
    var body = {
      "user_breadcrumb": "",
      "delivery_class": "organic",
      "idempotence_token": adID,
      "carousel_index": "0",
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "comment_text": text,
      "is_carousel_bumped_post": "false",
      "container_module": "comments_v2_clips_viewer_explore_popular_minor_unit",
      "feed_position": "0"
    };

    return reelsRequest(account, idToInteract, "comment", body);
  }

  static Future reelsRequest(
      InstagramAccount account, String mediaID, String op, body) async {
    String signature = Server.generateSignature(data: jsonEncode(body));

    Map<String, String> header = Server.createHeader(account, true);

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
