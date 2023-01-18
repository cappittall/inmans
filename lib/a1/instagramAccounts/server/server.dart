import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:inmans/a1/server/values.dart';

class Server {
  static Uuid uuid = const Uuid();

  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Future getDeviceInfo(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    String resolution =
        "${(size.height * pixelRatio).floor()}x${(size.width * pixelRatio).floor()}";
    String dpi = (pixelRatio * 160).floor().toString();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      String userAgent =
          "Instagram 184.0.0.30.117 Android (${androidDeviceInfo.version.sdkInt}/${androidDeviceInfo.version.release}; ${dpi}dpi; $resolution; ${androidDeviceInfo.manufacturer}; ${androidDeviceInfo.model}; ${androidDeviceInfo.version.codename}; ${androidDeviceInfo.product}; ${Platform.localeName}; 302733750)";
      setUserAgent(userAgent);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;

      String iosUserAgent =
          "Instagram 184.0.0.30.117 (${iosDeviceInfo.model}; iPhone OS ${iosDeviceInfo.systemVersion.replaceAll(".", "_")}; ${Platform.localeName}; ${Platform.localeName}; scale=$pixelRatio; $resolution; 302733750)";
      setUserAgent(iosUserAgent);
    }
  }

  static int randomNumber(int min, int max) {
    var random = Random();

    return min + random.nextInt(max - min);
  }

  static void setUserAgent(String agent) {
    userAgent = agent;
  }

  static void generateIDs() async {
    if (localDataBox.containsKey("idData")) {
      var idData = localDataBox.get("idData");
      appDeviceID = idData["appDeviceID"];
      instaDeviceID = idData["instaDeviceID"];
      phoneID = idData["phoneID"];
      pigeonID = idData["pigeonID"];
      adID = idData["adID"];
      guID = idData["guID"];
      waterfallID = idData["waterfallID"];
      osID = idData["androidID"];
      userAgent = idData["userAgent"];

      Map<String, String> data = {
        "appDeviceID": appDeviceID,
        "instaDeviceID": instaDeviceID,
        "phoneID": phoneID,
        "pigeonID": pigeonID,
        "adID": adID,
        "guID": guID,
        "waterfallID": waterfallID,
        "androidID": osID,
        "userAgent": userAgent,
      };

      //DataBaseManager.updateIDData(data);

    } else {
      appDeviceID = uuid.v4();
      instaDeviceID = uuid.v4();
      phoneID = uuid.v4();
      pigeonID = uuid.v4();
      adID = uuid.v4();
      guID = appDeviceID;
      waterfallID = uuid.v4();
      osID = await PlatformDeviceId.getDeviceId;

      Map<String, String> data = {
        "appDeviceID": appDeviceID,
        "instaDeviceID": instaDeviceID,
        "phoneID": phoneID,
        "pigeonID": pigeonID,
        "adID": adID,
        "guID": guID,
        "waterfallID": waterfallID,
        "androidID": osID,
        "userAgent": userAgent,
      };

      // DataBaseManager.updateIDData(data);

      localDataBox.put("idData", data);
    }
  }

  static Map<String, String> createHeader(
      InstagramAccount account, bool needsContentLength) {
    Map<String, String> headers = {
      'X-IG-App-Locale': 'tr_TR',
      'X-IG-Device-Locale': 'tr_TR',
      'X-IG-Mapped-Locale': 'tr_TR',
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': '1626522434.932',
      'X-IG-Bandwidth-Speed-KBPS': '599.000',
      'X-IG-Bandwidth-TotalBytes-B': '5532785',
      'X-IG-Bandwidth-TotalTime-MS': '11802',
      'X-IG-App-Startup-Country': 'TR',
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': account.claim,
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      'X-IG-Timezone-Offset': '10800',
      //'X-IG-Nav-Chain':
      //    '1nj:feed_timeline:6,CommentThreadFragment:comments_v2_feed_short_url:9',
      'X-IG-Connection-Type': 'MOBILE(LTE)',
      'X-IG-Capabilities': '3brTvx0=',
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'Authorization': account.authToken,
      'X-MID': account.mid,
      'IG-U-IG-DIRECT-REGION-HINT':
          '${account.rur},${account.dsUserID},${DateTime.now().millisecondsSinceEpoch}:01f79edfa32f5326d2f517011c92376b33034c2b54e28dc095d52f4743c766b915a57940',
      'IG-U-DS-USER-ID': account.dsUserID,
      'IG-U-RUR': account.rur,
      'IG-INTENDED-USER-ID': account.dsUserID,
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      //'Accept-Encoding': 'zstd, gzip, deflate',
      'Host': 'i.instagram.com',
      'Connection': ' keep-alive',
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "X-FB-Server-Cluster": "True",
      //'Content-Length': ' 699'
    };

    return headers;
  }

  static String generateSignature({data, skipQuote = false}) {
    var parsedData;
    if (!skipQuote) {
      parsedData = Uri.encodeComponent(data);
    } else {
      parsedData = data;
    }

    var keysig = "signed_body=SIGNATURE.$parsedData";
    return keysig;
  }

  static Map<String, String> headerType1(InstagramAccount account) {
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
      "retry_context": "json.dumps(self.imaj8)",

      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Cookie":
          "ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-SHBID": "3810",
      "IG-U-SHBTS": "1609266568.7728953",
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-Length": "length"

      /// ADD LENGTH
    };

    return header;
  }

  static Future postPicRequest1(
      endpoint, post, InstagramAccount account) async {
    var response = await http.post(Uri.parse(API_URL + endpoint),
        headers: headerType1(account), body: post);

    if (response.statusCode == 200) {
    } else {
      return null;
    }
  }

  static Future sendRequest2Get(endpoint, InstagramAccount account) async {
    Map<String, String> header = {
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "en-EN, en-US",
      "Cookie":
          "urlgen=urlgen; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "z-p42.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "Connection": "keep-alive",
    };

    var response =
        await http.get(Uri.parse(API_URL + endpoint), headers: header);

    if (response.statusCode == 200) {
    } else {
      return null;
    }
  }

  static Future sendRequest3(
      endpoint, InstagramAccount account, String post) async {
    Map<String, String> header = createHeader(account, true);

    var response = await http.post(Uri.parse(API_URL + endpoint),
        headers: header, body: post);

      if (response.statusCode > 203) print(jsonDecode(response.body)["message"]);      
    return response.statusCode;
  }

  static Future sendRequest4Get(endpoint, InstagramAccount account) async {
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
          "ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
    };

    var response =
        await http.get(Uri.parse(API_URL + endpoint), headers: header);

    if (response.statusCode == 200) {
      return [response.body, response.headers];
    } else {
      return null;
    }
  }

  static Map<String, String> profileHeader(InstagramAccount account) {
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
          "ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
    };

    return header;
  }

  static Future<int> getFollowerCount(InstagramAccount account) async {
    Uri uri = Uri.parse(
        "https://i.instagram.com/api/v1/users/" + "2238287305" + "/info/?from_module=self_profile");

    var response = await http.get(uri, headers: profileHeader(account));

    if (response.statusCode == 200) {
      int followerCount = jsonDecode(response.body)["user"]["follower_count"];

      if (followerCount != null) {
        return followerCount;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static Future<int> getGender(InstagramAccount account) async {
    Uri uri = Uri.parse(
        "https://i.instagram.com/api/v1/accounts/current_user/?edit=true");

    var response = await http.get(uri, headers: profileHeader(account));

    if (response.statusCode == 200) {
      int gender = jsonDecode(response.body)["user"]["gender"];

      if (gender != null) {
        return gender;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
