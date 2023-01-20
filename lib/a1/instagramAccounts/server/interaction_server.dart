import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'server.dart';
import '../../server/values.dart';

class InteractionServer {
  Future<http.Response> createUser(Map body) {
    return http.post(
      Uri.parse(url_local),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future findCommentID(
      {String userID, String mediaLink, InstagramAccount account}) async {
    try {
      if (!mediaLink.endsWith("/")) {
        mediaLink += "/";
      }

      var url =
          "https://togetherearn.com/api/v1/requestInteractionID/?type=commentID&value=$mediaLink&userID=$userID";

      var response = await http.get(Uri.parse(url), headers: {
        'Auth':
            'KzcrTerX6SagIPgE1ZLaTy8t33QVMDbsWPithWYaYbX7rpQcIcI_HpFpuApMrEIb'
      });

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String interactionID = data["interactionID"];

        return interactionID;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Map<String, String> createHeader(InstagramAccount account) {
  //   return {
  //     "X-IG-App-Locale": "tr_TR",
  //     "X-IG-Device-Locale": "tr_TR",
  //     "X-IG-Mapped-Locale": "tr_TR",
  //     "X-Pigeon-Session-Id": pigeonID,
  //     "X-Pigeon-Rawclienttime": "1609072393.620",
  //     "X-IG-Connection-Speed": 10000.toString() + "kbps",
  //     "X-IG-Bandwidth-Speed-KBPS": 9999999.toString(),
  //     "X-IG-Bandwidth-TotalBytes-B": 900000.toString(),
  //     "X-IG-Bandwidth-TotalTime-MS": 150.toString(),
  //     "X-IG-App-Startup-Country": "TR",
  //     "X-Bloks-Version-Id": bloksVersionID,
  //     "X-IG-WWW-Claim": account.claim,
  //     "X-Bloks-Is-Layout-RTL": "false",
  //     "X-Bloks-Is-Panorama-Enabled": "false",
  //     "X-IG-Device-ID": instaDeviceID,
  //     "X-IG-Android-ID": osID,
  //     "X-IG-Connection-Type": "WIFI",
  //     "X-IG-Capabilities": "3brTvx8=",
  //     "X-IG-App-ID": "567067343352427",
  //     "User-Agent": userAgent,
  //     "Accept-Language": "tr-TR, en-US",
  //     "Cookie":
  //         "csrfttoken=${account.csrftoken}; sessionId=${account.sessionID}; mid=${account.mid}; ig_direct_region_hint=ASH; rur=${account.rur}; ds_user_id=${account.dsUserID}",
  //     "Authorization": account.authToken,
  //     "X-MID": account.mid,
  //     "IG-U-IG-DIRECT-REGION-HINT": "ATN",
  //     "IG-U-DS-USER-ID": account.dsUserID,
  //     "IG-U-RUR": account.rur,
  //     "DEBUG-IG-USER-ID": account.dsUserID,
  //     "Accept-Encoding": "gzip, deflate",
  //     "Host": "z-p42.i.instagram.com",
  //     "X-FB-HTTP-Engine": "Liger",
  //     "X-FB-Client-IP": "True",
  //     "Connection": "keep-alive",
  //   };
  // }

  static Future<bool> hasLiked(
      {InstagramAccount account, String mediaID}) async {
    // result["items"][0]["has_liked"]

    Map<String, String> header = Server.createHeader(account, false);

    var response = await http.get(
        Uri.parse("https://i.instagram.com/api/v1/media/$mediaID/info/"),
        headers: header);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["items"][0]["has_liked"];
    } else {
      return false;
    }
  }

  static Future<bool> following(
      {InstagramAccount account, String accountID}) async {
    Map<String, String> header = Server.createHeader(account, false);

    var response = await http.get(
        Uri.parse(
            "https://i.instagram.com/api/v1/friendships/show/$accountID/"),
        headers: header);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["following"];
    } else {
      return false;
    }
  }

  static Future findAccountID(
    String userName,
  ) async {
    print(userName);
    // String endpoint =
    //     "fbsearch/topsearch_flat/?search_surface=top_search_page&timezone_offset=10800&count=30&query=$userName&context=blended";

    var url =
        "https://togetherearn.com/api/v1/requestInteractionID/?type=userID&value=$userName";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Auth':
            'KzcrTerX6SagIPgE1ZLaTy8t33QVMDbsWPithWYaYbX7rpQcIcI_HpFpuApMrEIb'
      },
    );

    print(response.body);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["status"] == "success") {
        return data["interactionID"].toString();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> getFollowerCount(String username) async {
    try {
      var url =
          "http://togetherearn.com/api/v1/requestInteractionID/?type=followerCount&value=$username";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Auth':
              'KzcrTerX6SagIPgE1ZLaTy8t33QVMDbsWPithWYaYbX7rpQcIcI_HpFpuApMrEIb'
        },
      );
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == "success") {
          return data["followerCount"];
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      print("Error on getting follower count returning 0");
      return 0;
    }
  }

  static Future findMediaID(String mediaLink) async {
    //String endpoint = "oembed/?url=$mediaLink";

    //var result = await Server.sendRequest4Get(endpoint, account);

    if (!mediaLink.endsWith("/")) {
      mediaLink += "/";
    }

    var url =
        "https://togetherearn.com/api/v1/requestInteractionID/?type=mediaID&value=$mediaLink";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Auth':
            'KzcrTerX6SagIPgE1ZLaTy8t33QVMDbsWPithWYaYbX7rpQcIcI_HpFpuApMrEIb'
      },
    );

    //return "2601605915528157626";

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        return data["interactionID"].toString();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future follow({InstagramAccount account, String idToInteract}) async {
    String followURL = "friendships/create/$idToInteract/";

    Map<String, String> data = {
      "user_id": idToInteract,
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": instaDeviceID,
      "nav_chain": "24F:explore_popular:2,UserDetailFragment:profile:3"
    };

    var result = await Server.sendRequest3(
        followURL, account, Server.generateSignature(data: jsonEncode(data)));
    return result;
  }

  static Future like({InstagramAccount account, String idToInteract}) async {
    String likeURL = "media/$idToInteract/like/";

    Map<String, String> body = {
      "delivery_class": "organic",
      "media_id": idToInteract,
      "carousel_index": "0",
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": phoneID,
      "nav_chain": "1nj:feed_timeline:6",
      "is_carousel_bumped_post": "false",
      "container_module": "feed_short_url",
      "feed_position": "0"
    };

    print("running post like");

    var result = await Server.sendRequest3(likeURL, account,
        Server.generateSignature(data: jsonEncode(body)) + "&d=1");

    return result;
  }

  static Future comment(
      {InstagramAccount account, String text, String idToInteract}) async {
    String commentURL = "media/$idToInteract/comment/";

    Map<String, String> body = {
      "user_breadcrumb": "",
      "delivery_class": "organic",
      "idempotence_token": adID,
      "carousel_index": "0",
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "nav_chain":
          "1nj:feed_timeline:6,CommentThreadFragment:comments_v2_feed_short_url:9",
      "comment_text": text,
      "is_carousel_bumped_post": "false",
      "container_module": "comments_v2_feed_contextual_profile",
      "feed_position": "0"
    };

    var result = await Server.sendRequest3(
        commentURL, account, Server.generateSignature(data: jsonEncode(body)));

    return result;
  }

  static Future likeComment(
      {InstagramAccount account, String idToInteract}) async {
    var body = {
      "delivery_class": "organic",
      "carousel_index": "0",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "is_carousel_bumped_post": "false",
      "container_module": "comments_v2_feed_contextual_profile",
      "feed_position": "1"
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    Map<String, String> header = Server.createHeader(account, true);

    String url = "media/$idToInteract/comment_like/";

    var response = await http.post(Uri.parse(API_URL + url),
        headers: header, body: signature);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"];
    }
  }

  // ignore: non_constant_identifier_names
  static Future DM(
      {InstagramAccount account, String text, String idToInteract}) async {
    String dmURL = "direct_v2/threads/broadcast/text/";

    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, String> body = {
      "recipient_users": "[[$idToInteract]]",
      "mentioned_user_ids": "[]",
      "action": "send_item",
      "is_shh_mode": "0",
      "send_attribution": "message_button",
      "client_context": timeStamp,
      "text": text,
      "device_id": osID,
      "mutation_token": timeStamp,
      "_uuid": guID,
      "offline_threading_id": timeStamp
    };

    var result = await Server.sendRequest3(
        dmURL, account, Server.generateSignature(data: jsonEncode(body)));

    return result;
  }

  static Future savePost(
      {InstagramAccount account, String idToInteract}) async {
    var body = {
      "module_name": "feed_contextual_profile",
      "_csrftoken": account.csrftoken,
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    Map<String, String> header = Server.createHeader(account, false);

    String url = API_URL + "media/$idToInteract/save/";

    var response =
        await http.post(Uri.parse(url), headers: header, body: signature);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"];
    }
  }
}
